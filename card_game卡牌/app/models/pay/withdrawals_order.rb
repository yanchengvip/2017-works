class Pay::WithdrawalsOrder < ApplicationRecord
  belongs_to :user
  validates :identifier, presence: true, uniqueness: true

  STATUS = {'transfer' => '待转账', 'complete' => '完成', 'cancel' => '取消'}


  class << self

    #身份证真实性验证
    def real_name_validation(id_number, alipay_name)
      res = JSON.parse(Faraday.new.post("http://op.juhe.cn/idcard/query?key=ec69c98d5d08cb6641bf1c8268762ee4&idcard=#{id_number}&realname=#{alipay_name}").body)
      return res["error_code"].to_i == 0 && res["result"]["res"].to_i == 1
    end

    #支付宝真实性验证
    def real_alipay_account params
      # parmas =  {out_biz_no: '987451',  amount: '0.1',  payee_account: 'zhang@163.com'}
      # true
      alipay_transfer({out_biz_no: "validation#{Time.now.strftime('%Y%m%d%H%M%S')}#{params[:alipay_account].gsub('@', '_').gsub('.', '_')}",  amount: '0.1',  payee_account: params[:alipay_account], payee_real_name: params[:alipay_name]})["code"].to_i == 10000

    end

    #支付宝转账
    def alipay_transfer parmas
      # parmas =  {out_biz_no: '987451',  amount: '0.1',  payee_account: 'zhang@163.com',payee_real_name: '张三'}
      alipay_params ={
          method: 'alipay.fund.trans.toaccount.transfer',
          biz_content: parmas.merge!({payee_type: 'ALIPAY_LOGONID'})
      }
      url = MyAlipay::Client.create_alipay_url alipay_params
      res = JSON.parse(RestClient.get(url))
      res['alipay_fund_trans_toaccount_transfer_response']
    end

    #用户申请提现
    def user_apply current_user, amount
      begin
        #提现限制配置min_amount=可提现的最小金额；charge_amount=小于此值，需要提现手续费；service_charge=提现手续费
        min_amount,charge_amount,service_charge = Pay::WithdrawalsOrder.withdrawals_limit
        account_ticket = AccountTicket.find(current_user.account_ticket.id)

        if amount < min_amount
          return {execResult: true, execMsg: "最低提现额度为#{min_amount}元", execErrCode: 403, execData: {}}
        end
        res  = {}
        account_ticket.with_lock do
          if account_ticket.balance.to_f < amount || amount == 0
            return {execResult: true, execMsg: '余额不足', execErrCode: 401, execData: {}}
          end
          if amount < charge_amount
            real_amount = amount - service_charge #实际到帐金额
          else
            real_amount = amount
            service_charge = 0
          end
          account_ticket.balance -= amount #余额
          account_ticket.withdrawals += amount #已提现金额
          account_ticket.save!
          @order = current_user.pay_withdrawals_orders.create!(amount: amount, real_amount: real_amount, service_charge: service_charge, status: 'transfer', identifier: MyUtils.time_random)
          current_user.account_ticket_balance_details.create!(fund: -amount, trad_type: 1)

          #直接转账
          alipay_params ={out_biz_no: @order.identifier, amount: @order.real_amount, payee_account: current_user.account_ticket&.alipay_account,payee_real_name: current_user.account_ticket&.alipay_name}
          res = Pay::WithdrawalsOrder.alipay_transfer alipay_params
          if res['code'] == '10000'
            @order.update_attributes!(status: 'complete', alipay_order_id: res['order_id'], pay_date: res['pay_date'], content: res)
            #发送预警短信
            send_waring_message amount
          else
            raise res["sub_msg"]
            # res = {execResult: true, execMsg: res["sub_msg"], execErrCode: 402, execData: {error: e.as_json}}
          end
        end
      rescue Exception => e
        return {execResult: true, execMsg: e.as_json, execErrCode: 402, execData: {error: e.as_json}}
      end
      return {execResult: true, execMsg: '提现成功，奖金已转到支付宝', execErrCode: 200, execData: {}}
    end


    #累计达到提现金额限制后发送短信
    def send_waring_message amount
      max_amount = $redis.incrby('withdrawals_max_amount', amount.to_i).to_i
      #取款累计达到此值，向财务发短信
      set = Setting.where(var: 'withdrawals_max_amount').active.first #累计金额最大限制，超过了就发短信
      set2 = Setting.where(var: 'withdrawals_waring_mobile').active.first #提现金额预警电话
      if max_amount >= (set&.value || '15000').to_i
        CardSms.send_message(set2&.value || '15810159353', "截止到目前，集分竞宝提现金额已达到上限，累计金额：#{max_amount}元")
        $redis.set('withdrawals_max_amount', 0)
      end
    end


    #提现限制的配置
    def withdrawals_limit
      s1 = Setting.where(var: 'withdrawals_min_amount').active.first #可提现的最小金额
      s2 = Setting.where(var: 'withdrawals_charge_amount').active.first #提现金额小于此值，需要提现手续费
      s3 = Setting.where(var: 'withdrawals_service_charge').active.first #提现手续费
      min_amount = s1&.value || 5
      charge_amount = s2&.value || 100
      service_charge = s3&.value || 2
      return min_amount.to_i, charge_amount.to_i, service_charge.to_i
    end


  end


end
