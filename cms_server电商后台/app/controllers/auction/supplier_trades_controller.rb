class Auction::SupplierTradesController < ApplicationController
  before_action :set_supplier_trade, only: [:freezed, :reject_cancel, :receive,:returning,:cancel]
  before_action :side_menus3
  skip_before_action :verify_authenticity_token, only: [:freezed, :reject_cancel, :receive, :return_status_records, :pay_records, :return_pay_records,:returning,:cancel]
  skip_before_action :login_filter, only: [:return_status_records, :pay_records, :return_pay_records]


  #供应商订单列表
  def index
    @bread_menu = {m1: '订单管理', m2: '拆分订单列表', m2_url: '/auction/supplier_trades', s: 'supplier_trade_search'}
    @trades = Supplier::Trade.includes(:account, :contact, :auction_trade)
                  .ransack(params[:q]).result.page(params[:page]).per(20)
  end


  #供应商订单详情
  def show
    @bread_menu = {m1: '订单管理', m2: '订单列表', m2_url: '/auction/trades', m3: '订单详情'}
    @supplier_trade = Supplier::Trade.includes(:account, :auction_trade, :units,
                                               :contact, :auction_products, :auction_skus).find(params[:id])

    @auction_trade = @supplier_trade.auction_trade
  end

  def edit

  end



  #驳回拒签，订单状态改为用户待收货
  def reject_cancel
    flash[:error] = '驳回拒签失败'
    if @trade.status == 'reject'
      @trade.update_attributes(status: 'receive')
      @trade.status_log('receive', params[:remark], current_user)
      flash[:error] = '驳回拒签成功'
    end
    redirect_to '/auction/trades?q[supplier_trade_status_eq]=reject&tab=7'
  end

  #拒签审核通过
  def freezed
    flash[:error] = '关闭订单失败'
    if @trade.status == 'reject'
      @trade.update_attributes(status: 'freezed')
      @trade.status_log('freezed', params[:remark], current_user)
      flash[:error] = '关闭订单成功'
    end
    redirect_to '/auction/trades?q[supplier_trade_status_eq]=reject&tab=7'
  end

  #退货订单列表
  def returns
    @bread_menu = {m1: '订单管理', m2: '退货管理', m2_url: '/auction/supplier_trades/returns', s: 'return_trade_search'}
    @tab = params[:tab].nil? ? 1 : params[:tab]
    if params[:q][:status_eq] == 'normal'
      params[:q].delete(:status_eq)
      params[:q] = params[:q].merge({status_null: 1})
    end
    @return_units = Auction::Unit.select('auction_units.*', 'auction_trades.identifier as trade_identifier','auction_trades.payment_service as payment_service')
                        .includes(:supplier_trade, :auction_product).joins(:trade)
                        .where('auction_trades.status not in (?) ', ['cancel', 'pay']).order('request_at desc')
                        .ransack(params[:q]).result.page(params[:page]).per(20)
  end

  def return_show
    @bread_menu = {m1: '订单管理', m2: '退货管理', m2_url: '/auction/supplier_trades/returns', m3: '退货商品详情'}
    @unit = Auction::Unit.includes(:trade, :supplier_trade, :auction_product, :auction_sku, :provider).find(params[:id])
  end


  #取消订单
  def cancel
    flash[:error] = '取消订单失败！'
    if @trade.status == 'ship' && @trade.auction_trade.payment_service == 'express'
      @trade.update_attributes(status: 'cancel')
      @trade.status_log('cancel', params[:remark], current_user)
      flash[:error] = '取消订单成功！'
    end
    redirect_to '/auction/trades?q[supplier_trade_status_eq]=ship&tab=4'
  end


  #确认收货
  def receive
    flash[:error] = '确认收货失败'
    if @trade.status == 'receive'
      @trade.update_attributes(status: 'complete')
      @trade.status_log('complete', params[:remark], current_user)
      flash[:error] = '确认收货成功'
    end
    redirect_to '/auction/trades?q[supplier_trade_status_eq]=receive&tab=6'
  end


  #订单申请退款
  def returning
    flash[:error] = '申请退款失败'
    begin
      if @trade.status == 'ship' && ['alipay','wechat'].include?(@trade.payment_price)
        ActiveRecord::Base.transaction do
          @trade.update_attributes!(status: 'returning')
          @trade.status_log('returning', params[:remark], current_user)
          trade_refund = @trade.trade_refunds.create!(auction_trade_id: @trade.auction_trade_id, auction_trade_identifier: @trade.auction_trade.identifier, supplier_trade_identifier: @trade.identifier, editor_id: current_user.id, user_id: @trade.user_id, remark: params[:remark], status: 'audit', amount: @trade.payment_price)
          trade_refund.trade_refund_logs.create!(editor_id: current_user.id,  status: 'audit', remark: params[:remark], user_id: @trade.user_id)
        end
        flash[:error] = '申请退款成功'
      end
    rescue Exception => e
    end
    redirect_to '/auction/trades?q[supplier_trade_status_eq]=ship&tab=4'
  end


  #订单状态操作记录
  def return_status_records
    render partial: 'auction/supplier_trades/return_modal/status_records'
  end


  #订单支付记录
  def pay_records
    render partial: 'auction/supplier_trades/return_modal/pay_records'
  end

  #订单退款支付记录
  def return_pay_records
    render partial: 'auction/supplier_trades/return_modal/return_pay_records'
  end





  private
  # Use callbacks to share common setup or constraints between actions.
  def set_supplier_trade
    @trade = Supplier::Trade.includes(:auction_trade).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def supplier_trade_params
    params.require(:supplier_trade).permit(:auction_trade_id, :provider_id, :status, :price, :payment_price, :tax_price, :active, :delivery_service, :delivery_identifier, :ship_at, :remark, :delivery_phone, :balance_price, :finish_at)
  end
end
