class Manage::HomesController < ApplicationController
  before_action :side_menus1

  def index
    today_trades = Auction::Trade.where("created_at >= ? and created_at <= ? and  payment_service <> null",Time.now.beginning_of_day.strftime("%Y-%m-%d %H:%m:%S"),Time.now.end_of_day.strftime("%Y-%m-%d %H:%m:%S"))
    @trade_today_count = today_trades.count
    @trade_today_sum = today_trades.sum(:payment_price)

    yesterday_trades = Auction::Trade.where("created_at >= ? and created_at <= ? and  payment_service <> null",Time.now.yesterday.beginning_of_day.strftime("%Y-%m-%d %H:%m:%S"),Time.now.yesterday.end_of_day.strftime("%Y-%m-%d %H:%m:%S"))
    @trade_today_yesterday_count = yesterday_trades.count
    @trade_today_yesterday_sum = yesterday_trades.sum(:payment_price)
  end
end
