class Api::WithdrawalsOrdersController < Api::ApplicationController

  #用户当前账户信息
  def balance_detail
    at = current_user.account_ticket
    is_bind_alipay = false
    if at.alipay_account.present? && at.alipay_name.present? &&  at.id_number.present?
      is_bind_alipay = true
    end

    #提现限制配置min_amount=可提现的最小金额；charge_amount=小于此值，需要提现手续费；service_charge=提现手续费
    min_amount,charge_amount,service_charge = Pay::WithdrawalsOrder.withdrawals_limit
    #当前可取金额，只能提现整数值
    use_balance = at.balance.to_f >= min_amount ? at.balance.to_i : 0

    if use_balance >= charge_amount
      #无手续费
      real_balance = use_balance
    elsif use_balance == 0
      real_balance = 0
    else
      real_balance = use_balance - service_charge
    end

    render json: {
        is_bind_alipay: is_bind_alipay, #是否绑定支付宝 false=未绑定
        balance: at.balance.to_f, #当前可用总金额
        use_balance: use_balance.to_f, #当前可取金额，只能提现整数值
        real_balance: real_balance.to_f, #用户实际到账金额
        withdrawals: (BigDecimal.new(at.withdrawals.present? ? at.withdrawals.to_s : '0') + BigDecimal.new(at.balance.present? ? at.balance.to_s : '0')).to_f, #累计金额
        alipay_account: at.alipay_account, #支付宝账号
        alipay_name: at.alipay_name, #支付宝真实姓名
        withdrawl: {
            min_money: min_amount, #可提现的最小金额
            charge_amount: charge_amount, #小于此值，需要提现手续费
            service_charge: service_charge #提现手续费
        }
    }
  end

  #提现记录
  def index
    @orders = current_user.pay_withdrawals_orders.active.order('created_at desc').page(params[:page]).per(20)
  end


  #奖金明细列表
  def balance_list
    @balance_details = current_user.account_ticket_balance_details.active.order('id desc').page(params[:page]).per(20)
  end


  #绑定用户的支付宝账号
  def bind_alipay
    flag = {execResult: true, execMsg: '系统繁忙请稍后再试!', execErrCode: 400, execData: {}}
    # if params[:alipay_account] != params[:confirm_alipay_account]
    #   render json: {execResult: true, execMsg: '两次支付宝账号不一致!', execErrCode: 401, execData: {}} and return
    # end
    if (current_user.account_ticket.alipay_account.present? && current_user.account_ticket.alipay_name.present? && current_user.account_ticket.id_number.present?)
      render json: {execResult: true, execMsg: '用户已绑定支付宝账号!', execErrCode: 402, execData: {}} and return
    end

    if params[:id_number] && params[:alipay_account] && params[:alipay_name]
      if $redis.incrby("validation:#{current_user.id}", 1) > 3
        $redis.expire("validation:#{current_user.id}", 48 * 3600)
        flag = {execResult: false, execMsg: '多次绑定失败账户已锁定，请联系客服解锁', execErrCode: "5000", execData: {}}
        render json: flag and return
      end

      unless  AccountTicket.where("id_number = ?", params[:id_number]).blank?
        flag = {execResult: false, execMsg: '身份证号已使用', execErrCode: "5001", execData: {}}
        render json: flag and return
      end

      unless  AccountTicket.where("alipay_account = ?", params[:alipay_account]).blank?
        flag = {execResult: false, execMsg: '支付宝账号已使用', execErrCode: "5002", execData: {}}
        render json: flag and return
      end


      unless Pay::WithdrawalsOrder.real_name_validation(params[:id_number], params[:alipay_name])
        flag = {execResult: false, execMsg: '身份证号与姓名不一致', execErrCode: "5003", execData: {}}
        render json: flag and return
      end

      unless Pay::WithdrawalsOrder.real_alipay_account(params)
        flag = {execResult: false, execMsg: '支付宝真实姓名与账号不一致', execErrCode: "5004", execData: {}}
        render json: flag and return
      end

      s = current_user.account_ticket.update_attributes({alipay_account: params[:alipay_account], id_number: params[:id_number], alipay_name: params[:alipay_name]})
      flag = {execResult: true, execMsg: '绑定支付宝成功!', execErrCode: 200, execData: {}} if s
    end

    render json: flag
  end

  #申请提现
  def apply
    amount = params[:amount].to_i #提现金额，必须为整数
    if current_user.card_user_third_parties.where(type: 0).blank?
      render json: {"execResult" => false, "execMsg" => "请绑定微信", "execData" => {}, "execDatas" => [], "execErrCode" => "1707"} and return
    end
    if current_user.mobile.nil?
      render json: {"execResult" => false, "execMsg" => "请绑定手机号", "execData" => {}, "execDatas" => [], "execErrCode" => "1708"} and return
    end
    if (!current_user.account_ticket&.alipay_name.present? || !current_user.account_ticket&.alipay_account.present?)
      render json: {"execResult" => false, "execMsg" => "请关联支付账户和真实姓名", "execData" => {}, "execDatas" => [], "execErrCode" => "402"} and return
    end
    res = Pay::WithdrawalsOrder.user_apply(current_user, amount)
    render json: res
  end


end
