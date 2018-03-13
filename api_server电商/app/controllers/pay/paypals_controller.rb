class Pay::PaypalsController < ApplicationController
  include PayPal::SDK::REST
  # def show
  # end
  #trade_id, return_url
  def create
    if params[:trade_id].blank? || params[:return_url].blank?
      render json: {status: 500, msg: "订单号或返回url为空", data: {}} and return
    end
    trade = Auction::Trade.detail ({user_id: current_user['id'],trade_id: params[:trade_id]})
    if !trade['data'].present? || trade['data']['payment_price'].to_f  == 0
      render json: {status: 500, msg: "支付失败,订单参数有误", data: {}} and return
    end
    product_names = trade['data']['units'][0]['name'].to_s + '...等'
    items =[]
    trade['data']['units'].each do |u|
      items << {
            :name => u['name'],
            :sku => u["sku_name"],
            :price => Auction::ExchangeRate.exchange(u["price"].to_f, Setting.pay["pay_list"]["paypal"]["currency"]),
            :currency => Setting.pay["pay_list"]["paypal"]["currency"],
            :quantity => 1 }
    end

    @payment = Payment.new({
      :intent =>  "sale",
      :payer =>  {
        :payment_method =>  "paypal" },
      :redirect_urls => {
        :return_url => params[:return_url],
        :cancel_url => params[:return_url]},
      :transactions =>  [{
        :item_list => {
          :items => items},
        :amount =>  {
          :total =>  Auction::ExchangeRate.exchange(trade['data']['payment_price'], Setting.pay["pay_list"]["paypal"]["currency"]),
          :currency =>  Setting.pay["pay_list"]["paypal"]["currency"] },
        :description =>  trade['data']['trade_id'] }]})

    if @payment.create
      render json: {status: 200, data: {url: @payment.approval_url, payment_id: @payment.id, items: items, currency: Setting.pay["pay_list"]["paypal"]["currency"], total: Auction::ExchangeRate.exchange(trade['data']['payment_price'], Setting.pay["pay_list"]["paypal"]["currency"]) }.as_json, msg: "success"}
    else
      render json:{status: 500, data: {}, msg: "error"}
    end
  end

  def execute
    # paymentId=PAY-9XG046656L3376503LHVO6BA&token=EC-12635216M6495133W&PayerID=ZK2S3LDSC6PTC"
    payment = Payment.find(params[:paymentId])
    trade = Auction::Trade.detail ({user_id: current_user['id'],trade_id: payment.transactions.first.description })

    if trade && trade['data'] && Auction::ExchangeRate.exchange(trade['data']['payment_price'].to_f, Setting.pay["pay_list"]["paypal"]["currency"])  == payment.transactions.first.amount.total.to_f && payment.transactions.first.amount.currency == Setting.pay["pay_list"]["paypal"]["currency"]

      if payment.state == 'approved' || payment.execute( :payer_id => payment.payer.payer_info.payer_id )
        # trade = Auction::Trade.detail ({user_id: current_user['id'],trade_id: payment.transactions.first.description })
        p1 = {
          'userId': current_user['id'],
          'auctionTradeId': trade['data']['trade_id'],
          'outTradeNo': trade['data']['identifier'],
          'payType': 4,
          'tradeNo': params[:paymentId],
          'tradeStatus': 1,
          'notifyId': params[:paymentId],
          'notifyTime':  payment.create_time,
          'gmtPayment':  payment.create_time,
          'buyerId': payment.payer.payer_info.payer_id,
          'sellerId': "",
          'totalAmount':  payment.transactions.first.amount.total.to_f,
          'receiptAmount': payment.transactions.first.amount.total.to_f - payment.transactions.first.related_resources.first.sale.transaction_fee.value.to_f ,
          'buyerPayAmount': payment.transactions.first.amount.total.to_f,
          'content': payment.as_json,
          'buyerLogonId': payment.payer.payer_info.email
        }
        Auction::Trade.pay_item_callback p1 if trade["data"]["payment_service"].blank?

        render json: {status: 200, data: {trade_id: payment.transactions.first.description, payment: payment.as_json}, msg: "success"}
      else
        render json: {status: 500, data: {trade_id: payment.transactions.first.description, payment: payment.as_json}, msg: "faild", err_hash: payment.error}
         # Error Hash
      end
    else
      render json: {status: 500, data: {}, msg: "订单信息不正确", err_hash: payment.error}
    end
  end
end
