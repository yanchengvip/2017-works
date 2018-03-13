class Auction::CashiersController < ApplicationController
  before_action :set_supplier_trade, only: [:collect_money, :pay_detailed]
  before_action :side_menus3

  def index
    @bread_menu = {m1: '财务收款管理', m2: '财务收款', m2_url: '/auction/cashiers', s: 'cashiers_search'}
    @trades = Supplier::Trade.includes(:account, :contact, :auction_trade)
                  .ransack(params[:q]).result.page(params[:page]).per(20)
  end


  def show
    @bread_menu = {m1: '财务收款管理', m2: '详情', m2_url: '/auction/cashiers', m3: '订单详情'}
    @supplier_trade = Supplier::Trade.includes(:account, :auction_trade, :units,
                                               :contact, :auction_products, :auction_skus).find(params[:id])

    @auction_trade = @supplier_trade.auction_trade
  end

  def pay_detailed
    @bread_menu = {m1: '财务收款管理', m2: '订单相关支付记录', m2_url: '/auction/cashiers', m3: '订单相关支付记录'}
    @pay_items =  Pay::Item.where(supplier_trade_no: @trade.identifier)
  end

  def collect_money
    if !params[:pay_item][:buyer_pay_amount].blank? && !params[:pay_item][:trade_no].blank?
       Pay::Item.create(:buyer_pay_amount => params[:pay_item][:buyer_pay_amount],:pay_type => params[:pay_item][:pay_type], :trade_no => params[:pay_item][:trade_no], :gmt_payment => params[:pay_item][:gmt_payment], :remark => params[:pay_item][:remark], :supplier_trade_no => @trade.identifier, :user_id => current_user.id )
       received_price = @trade.received_price.nil? ? 0 : @trade.received_price
       wait_price = @trade.price.to_f - received_price
       if params[:pay_item][:buyer_pay_amount].to_f >= wait_price
         @trade.update(:pay_status => "1",:received_price => received_price + params[:pay_item][:buyer_pay_amount].to_f)
       elsif params[:pay_item][:buyer_pay_amount].to_f < wait_price
         @trade.update(:pay_status => "3",:received_price => received_price + params[:pay_item][:buyer_pay_amount].to_f)
       end
      flash[:success] = 'success'
      return redirect_to action: :index
    else
      flash[:danger] = "填写正确的收款信息"
      return redirect_to '/auction/cashiers'
    end
  end

  def batch_search
    @bread_menu = {m1: '财务收款管理', m2: '财务收款', m2_url: '/auction/cashiers', s: 'cashiers_search'}
    params[:q] ||= {}
    if params[:item_type_name] == "delivery_identifier"
      params[:q][:delivery_identifier_in] = params[:pids].gsub(/\s+/,'').split(",") if params[:pids] && params[:pids].is_a?(String)
    elsif params[:item_type_name] == "supplier_trade_no"
      params[:q][:identifier_in] = params[:pids].gsub(/\s+/,'').split(",") if params[:pids] && params[:pids].is_a?(String)
    elsif params[:item_type_name] == "auction_trade_no"
      params[:q][:auction_trade_identifier_in] = params[:pids].gsub(/\s+/,'').split(",") if params[:pids] && params[:pids].is_a?(String)
    end
    @trades = Supplier::Trade.includes(:account, :contact, :auction_trade).ransack(params[:q]).result.page(params[:page]).per(20)
    render :index
  end

  private

  def set_supplier_trade
    @trade = Supplier::Trade.find(params[:id])
  end


  def supplier_trade_params
    params.require(:supplier_trade).permit(:pay_type, :trade_no, :gmt_payment, :remark, :buyer_pay_amount)
  end

end
