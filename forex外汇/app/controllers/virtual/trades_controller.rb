class Virtual::TradesController < ApplicationController

  def index
    @trades = current_account.virtual_trades.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  #建仓
  def create
    if [0, 1].include?(params[:cmd].to_i)
      #市价交易
      res = Virtual::Trade.trade_by_volumes current_account, trade_params
    elsif [2, 3, 4, 5].include?(params[:cmd].to_i)
      #挂单
      trade = current_account.virtual_trades.create!(trade_params)
      res = {status: 200, msg: '交易成功！', data: {trade_id: trade.id}}
    end

    render json: res
  end

  #平仓
  def trade_close
    trade = current_account.virtual_trades.where(id: params[:id], cmd: [0, 1], close_time: '1970-01-01 00:00:00').first
    render json: {status: 503, msg: '订单不存在', data: {}} if trade.nil?
    res = trade.trade_close current_account
    render json: res
  end

  def show
    @trade = current_account.virtual_trades.where(id: params[:id]).first
  end


  private
  def trade_params
    params.permit(:symbol, :cmd, :price, :volume, :expiration, :sl, :tp)
  end
end
