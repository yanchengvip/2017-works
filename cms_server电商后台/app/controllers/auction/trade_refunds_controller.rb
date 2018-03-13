class Auction::TradeRefundsController < ApplicationController
  before_action :side_menus3
  skip_before_action :verify_authenticity_token, only: [:transfer]


  def index
    @bread_menu = {m1: '订单管理', m2: '退款订单列表', m2_url: '/auction/trade_refunds', s: 'trade_search'}
    @trade_refunds = Auction::TradeRefund.includes(:account, :editor, :auction_trade).active.ransack(params[:q]).result
                         .order(created_at: :desc).page(params[:page]).per(20)
    @tab = params[:tab].nil? ? 1 : params[:tab]
  end

  #财务退款
  def transfer
    flag = '退款失败！'
    begin
      ActiveRecord::Base.transaction do
        trade_refund = Auction::TradeRefund.includes(:supplier_trade).find(params[:id])
        trade_refund.update_attributes!(return_amount: params[:return_amount],status: 'complete') #实际退款金额
        trade_refund.supplier_trade.update_attributes!(status: 'return') #退款成功
        trade_refund.trade_refund_logs.create!(editor_id: current_user.id, remark: params[:remark], status: 'complete')
        flag = '退款成功！'
      end
    rescue Exception => e

    end

    redirect_to '/auction/trade_refunds?q[status_eq]=transfer&tab=3', notice: flag
  end


end