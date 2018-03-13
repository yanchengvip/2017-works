class AccountTradersController < ApplicationController


  #跟投
  def create
    trader = Account.find(params[:trader_id])
    if trader.typee == 0
      render json: {status: 501, msg: "被跟随的必须是交易员", data: {}} and return
    end
    if current_account.typee == 1
      render json: {status: 501, msg: "跟投者必须是普通用户", data: {}} and return
    end
    if current_account.margin_free.to_f >= params[:follow_amount].to_f && trader.typee == 1
      current_account.account_traders.create!(account_trader_params)
    else
      render json: {status: 500, msg: "可用保证金不足", data: {}} and return
    end
    render json: {status: 200, msg: "跟投成功", data: {}}

  end


  private

  def account_trader_params
    params.permit(:trader_id, :follow_amount, :follow_type, :status)
  end

end
