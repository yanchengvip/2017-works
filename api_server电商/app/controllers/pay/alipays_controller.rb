class Pay::AlipaysController < ApplicationController
  # skip_before_action :verify_authenticity_token


  def index
    render json: 'ok'
  end

  #国内支付
  def new
    begin
      #识别浏览器
      Rails.logger.info("alipay_new"+'==='*10)
      Rails.logger.info(params.as_json)
      device_type = params[:device_type]
      browser = Browser.new(request.user_agent, accept_language: "en-us")
      unless Setting.pay['pay_list']['alipay']['use']
        render json: {status: 500, msg: "不支持支付宝支付！", data: {}} and return
      end
      device_type ||= 1 if !browser.device.mobile? #PC浏览器
      device_type ||= 2 if browser.device.mobile? && !browser.wechat? #手机非微信浏览器
      if !device_type
        render json: {status: 500, msg: "参数错误，浏览器不支持", data: {}} and return
      end
      trade = Auction::Trade.detail ({user_id: current_user['id'], trade_id: params[:trade_id]})
      if !trade['data'].present?
        render json: {status: 500, msg: "订单查询失败，稍后重试", data: {}} and return
      end
      price = Auction::Trade.count_alipay_price(trade['data']['payment_price'].to_f)
      if price == 0
        render json: {status: 500, msg: "支付失败,订单金额有误", data: {}} and return
      end
      product_names = trade['data']['units'][0]['name'].to_s + "共#{trade['data']['units'].size}件"
      pay_params = {
          name: product_names,
          device_type: device_type,
          out_trade_no: trade['data']['identifier'],
          price: price,
          return_url: params[:return_url]
      }
      case Setting.pay['pay_list']['alipay']['currency']
        when 'CNY'
          res = Auction::Trade.alipay pay_params
        when 'USD'
          res = Auction::Trade.alipay_global pay_params
      end
      url = res[:data][:url]
      #redirect_to url and return
      render json: {status: 200, msg: "支付成功", data: {url: url}} and return
    rescue Exception => e
      Rails.logger.info('alipay_error'+"==="*10)
      Rails.logger.info(e)
      render json: {status: 500, msg: "支付失败", data: {error: e}} and return
    end
  end


  #回调验签
  def notify
    flag = 'false'
    trade = Auction::Trade.detail ({identifier: params[:out_trade_no], type: 1})
    if params[:currency] == 'USD'
      flag = global_notify params, trade
    else
      flag = dalu_notify params, trade
    end
    render json: flag
  end


  private

  #境内支付
  def dalu_notify params, trade
    is_verify = MyAlipay::Notify.verify? params.as_json
    pay_price = Auction::Trade.count_alipay_price(trade['data']['payment_price'].to_f)
    if is_verify && pay_price == params[:total_amount].to_f
      p1 = {'userId': 1,
            'auctionTradeId': trade['data']['trade_id'],
            'outTradeNo': params[:out_trade_no],
            'payType': 1,
            'tradeNo': params[:trade_no],
            'tradeStatus': 1,
            'notifyId': params[:notify_id],
            'notifyTime': params[:notify_time],
            'gmtPayment': params[:gmt_payment],
            'buyerId': params[:buyer_id],
            'sellerId': params[:seller_id],
            'totalAmount': params[:total_amount],
            'receiptAmount': params[:receipt_amount],
            'buyerPayAmount': params[:buyer_pay_amount],
            'content': params.as_json,
            'buyerLogonId': params[:buyer_logon_id]

      }
      Auction::Trade.pay_item_callback p1
      flag = 'success'
    end
    return flag
  end

  #境外支付回调
  def global_notify params, trade
    params.delete('sign_type')
    params.delete('controller')
    params.delete('action')
    sign = params.delete('sign')
    str = MyAlipay::Utils.params_to_string params.as_json.stringify_keys
    is_verify = MyAlipay::Sign::MD5.verify?(ALIPAYCONFIG[:alipay_global][:private_key], str, sign)
    if is_verify && params[:currency] == 'USD'
      p1 = {'userId': 1,
            'auctionTradeId': trade['data']['trade_id'],
            'outTradeNo': params[:out_trade_no],
            'payType': 1,
            'tradeNo': params[:trade_no],
            'tradeStatus': 1,
            'notifyId': params[:notify_id],
            'notifyTime': params[:notify_time],
            'gmtPayment': params[:gmt_payment],
            'buyerId': params[:buyer_id],
            'sellerId': params[:seller_id],
            'totalAmount': params[:total_fee],
            'receiptAmount': params[:receipt_amount],
            'buyerPayAmount': params[:buyer_pay_amount],
            'content': params.as_json,
            'buyerLogonId': params[:buyer_logon_id]

      }
      Auction::Trade.pay_item_callback p1
      flag = 'success'
    end
    return flag
  end
end
