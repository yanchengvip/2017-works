class Auction::VoucherTradesController < ApplicationController
  include PayPal::SDK::REST
  # layout 'voucher_trades/application'
  # skip_filter :authorized?, only: [:alipay_notify]
  # skip_filter :sign_is_valid?, only: [:alipay_notify]


  ##
  # == 购买优惠券
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /auction/voucher_trades/new
  #
  # ==== Parameters
  #
  #
  #
  # === Response
  #
  #
  def new
    @events = Auction::Event.active.where(is_sell: true).as_json(Auction::Event.xml_options)
    @is_micro_products = Rails.cache.fetch("voucher_trades_is_micro_products",  expires_in: 60){
        Auction::Product.active.includes(:brand).where(is_micro: true).order(updated_at: :desc).limit(6).as_json(Auction::Product.voucher_trade_xml_options).to_a
      }
    @is_hot_products = Rails.cache.fetch("voucher_trades_is_hot_products",  expires_in: 60){
        Auction::Product.active.includes(:brand).where(is_hot: true).order(updated_at: :desc).limit(6).as_json(Auction::Product.voucher_trade_xml_options).to_a
      }
    render json: {status: 200, data:{events: @events, is_micro_products: @is_micro_products, is_hot_products: @is_hot_products}, msg: "success"}
  end

  ##
  # == 购买优惠券 支付接口
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /auction/voucher_trades
  #
  # ==== Parameters
  #
  # sign :: 签名
  # amount :: 购买数量
  #
  #
  #
  # === Response
  #
  #Auction::VoucherTrade(id: integer, user_id: integer, event_id: integer, amount: decimal, payment_price: decimal, payment_service: string, payment_identifier: string, payment_time: datetime, status: integer, active: boolean, created_at: datetime, updated_at: datetime)
  # @current_user

  def create
    event =  Auction::Event.find(params[:voucher_trade][:event_id])
    if event && event.is_sell
      voucher_trade = Auction::VoucherTrade.create({ user_id: current_user["id"], event_id: event.id, payment_price: event.price, amount: 1 } )
      render json: {status: 200, data: {voucher_trade: voucher_trade, event: event}, msg: "success"}
    else
      render json: {status: 500, data: {}, msg: "error"}
    end
  end

  def show
    @voucher_trade = Auction::VoucherTrade.where(id: params[:id], user_id: current_user["id"]).last
    @event = @voucher_trade.event
    if @voucher_trade
      render json: {status: 200, data: {voucher_trade: @voucher_trade, event: @event}, msg: "success"}
    else
      redirect_to "/404"
    end
  end

  def checkout
    if params[:id] &&( params[:payment_service] == "alipay" || params[:payment_service] == "paypal" )&& (voucher_trade = Auction::VoucherTrade.find(params[:id])) && voucher_trade.user_id == current_user["id"] && !params[:return_url].blank?
      pay_url = ""
      if(params[:payment_service] == 'alipay')
        pay_url = voucher_trade.alipay_url(params)
      elsif params[:payment_service] == 'paypal'
        payment = Payment.new({
              :intent =>  "sale",
              :payer =>  {
                :payment_method =>  "paypal" },
              :redirect_urls => {
                :return_url => params[:return_url],
                :cancel_url => params[:return_url] },
              :transactions =>  [{
                :item_list => {
                  :items => [{
                    :name => voucher_trade.event.name,
                    :sku => "item",
                    :price => Auction::ExchangeRate.exchange(voucher_trade.payment_price, Setting.pay["pay_list"]["paypal"]["currency"]),
                    :currency => Setting.pay["pay_list"]["paypal"]["currency"],
                    :quantity => 1 }]},
                :amount =>  {
                  :total =>  Auction::ExchangeRate.exchange(voucher_trade.payment_price, Setting.pay["pay_list"]["paypal"]["currency"]),
                  :currency =>  Setting.pay["pay_list"]["paypal"]["currency"] },
                :description =>  "voucher_trade##{voucher_trade.id}" }]})
        if payment.create
          pay_url = payment.approval_url
        else
          pay_url = params[:return_url]
        end
      end
      render json:{status: 200, data: {pay_url: pay_url}}
    else
      render json:{status: 500, msg: "404"}
    end
  end

  def execute
    payment = Payment.find(params[:paymentId])
    Rails.logger.info(current_user)
    voucher_trade = Auction::VoucherTrade.where(user_id: current_user['id'],id: payment.transactions.first.description.split("#").last).first
    if voucher_trade

      if payment.execute( :payer_id => params[:PayerID] )
        res = false
        voucher_trade.with_lock do
          if voucher_trade.status == 0
            voucher_trade.status = 1
            voucher_trade.payment_service = "paypal"
            voucher_trade.payment_identifier = payment.id
            voucher_trade.save!
            res = true
          end
        end
        if res
          voucher_trade.score_items.create!(amount: voucher_trade.cal_recharge_amount, out_trade_no: voucher_trade.out_trade_no, user_id: voucher_trade.user_id)
          voucher_trade.create_voucher
        end

        render json: {status: 200, data: {voucher_trade_id: voucher_trade.id}, msg: "success"}
      else
        render json: {status: 500, data: {}, msg: "faild", err_hash: payment.error}
      end
    else
      render json: {status: 500, data: {}, msg: "订单不存在"}
       # Error Hash
    end
  end

  def alipay_notify
    @voucher_trade = Auction::VoucherTrade.acquire(params[:out_trade_no].last(15).to_i)
    if @voucher_trade.alipay_notify(params.except(*request.path_parameters.keys))
      render :text => "success", :layout => false
    else
      render :text => "fail", :layout => false
    end
  end

  def alipay_return
    if params[:out_trade_no]
      @voucher_trade = Auction::VoucherTrade.acquire(params[:out_trade_no].last(15).to_i)
      @voucher_trade.alipay_notify(params.except(*request.path_parameters.keys))
    else
      @voucher_trade = Auction::VoucherTrade.where(user_id: @current_user["id"]).acquire(params[:id])
    end
    render json: {status: 200, data: {voucher_trade: @voucher_trade }, msg: "success"}
    # render "status"
  end
end
