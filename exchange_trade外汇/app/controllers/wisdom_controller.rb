class WisdomController < ApplicationController
  skip_before_action :check_auth
  # 开户回调接口
  #
  # GET/POST /wisdom/external_account_callback
  #
  # @param merchno [string] 客户号
  # @param login [string] Mt4账号
  # @param pwd [string] 交易密码
  # @param redpwd [string] 只读密码
  # @param message [string] 回传讯息
  # @param status [string] 交易状态 0-申请成功 1-申请失败 2-账户开立
  #
  # @return ({status: 200})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def external_account_callback
    if Api::Wisdom.signature(params, [:merchno, :twid, :login, :pwd, :redpwd, :message, :status]) == params[:signature]
      if params[:status].to_s == '0' || params[:status].to_s == '2'
        user = User.find(params[:user_id])
        dealer_id = Dealer.where(dealer_type: 2).first&.id
        data = {dealer_id: dealer_id, dealer_type: 2, status: 1, mt4_account: params[:login], name: params[:name], phone: params[:phonecode], email: params[:email], certificate: "身份证", certificate_num: params[:twid], pwd: params[:pwd], redpwd: params[:redpwd]}
        if account = user.accounts.where(dealer_type: 2).first
          account.update(data)
        else
          user.accounts.create(data)
        end
      end
    else
      Rails.logger.info("*"*100)
    end
    render json:{ status: 200}
  end

  # 入金申请返回接口
  #
  # GET/POST /wisdom/external_deposit_callback
  #
  # @param merchno [string] 客户号
  # @param login [string] Mt4账号
  # @param balance [double] 该帐号余额
  # @param message [string] 回传讯息
  # @param status [string] 交易状态 0-申请成功 1-申请失败 2-入/出 金完成
  #
  # @return ({status: 200})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def external_deposit_callback
    if Api::Wisdom.signature(params, [:merchno, :login, :balance, :message, :status]) == params[:signature]
      account = Account.find(params[:account_id])
      if account.login == params[:login]
        dealer_id = Dealer.where(dealer_type: 2).first&.id
        data = {dealer_id: dealer_id, amount: params[:amount], balance: params[:balance], status: params[:status], type: params[:type]}

        if params[:status].to_s == '0'
          account.financial_records.create(data)
        else
          financial_record = account.financial_records.where(status: 0, amount: params[:amount]).first
          financial_record.update(data)
        end
      else
      end
    else
      Rails.logger.info("signature error")
    end
    render json:{ status: 200}
  end

  # 出金申请返回接口
  #
  # GET/POST /wisdom/external_withdraw_callback
  #
  # @param (see #external_deposit_callback)
  #
  # @return ({status: 200})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def external_withdraw_callback
    if Api::Wisdom.signature(params, [:merchno, :login, :balance, :message, :status]) == params[:signature]
      account = Account.find(params[:account_id])
      if account.login == params[:login]
        dealer_id = Dealer.where(dealer_type: 2).first&.id
        if params[:status].to_s == '0'
          account.financial_records.create(dealer_id: dealer_id, amount: params[:amount], balance: params[:balance], status: params[:status])
        else
          financial_record = account.financial_records.where(status: 0, amount: params[:amount]).first
          financial_record.update(dealer_id: dealer_id, amount: params[:amount], balance: params[:balance], status: params[:status])
        end
      else
      end
    else
      Rails.logger.info("signature error")
    end
    render json:{ status: 200}
  end
end
