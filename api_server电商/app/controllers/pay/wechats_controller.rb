class Pay::WechatsController < ApplicationController
  # skip_before_action :verify_authenticity_token
  wechat_api
  wechat_responder


  #手机微信浏览器支付,微信支付优惠2%,支付宝支付优惠1%
  def mobile_wx_pay
    Rails.logger.info("mobile_wechat_pay"*10)
    @return_url = params[:return_url]
    begin
      page_url =  Setting.hosts + "api" + request.original_fullpath

      # https://127.0.0.1:3000&redirect_uri=http%3A%2F%2Ftest-api-server.ihaveu.com%2F%2Fpay%2Fwechats%2Fmobile_wx_pay%3Freturn_url%3Dhttp%253A%252F%252Ftest-touch.ihaveu.com%252F%26trade_id%3D40340&response_type=code&scope=snsapi_base&state=d783d0b58ecdac4b6b62638a24478ee7#wechat_redirect

      wechat_oauth2(scope = 'snsapi_base', page_url) do |openid|
        signature = Wechat.api.jsapi_ticket.signature(request.url)
        @jsapi_ticket = {
            appid: WxPay.appid,
            noncestr: signature[:noncestr],
            timestamp: signature[:timestamp],
            jsapi_ticket: signature[:jsapi_ticket],
            url: signature[:url],
            signature: signature[:signature],

        }
        trade = Auction::Trade.detail ({trade_id: params[:trade_id],type: 1})
        if !trade['data'].present?
          render json: {status: 500, msg: "订单查询失败，稍后重试", data: {}} and return
        end
        total_fee = Auction::Trade.count_wechat_price(trade['data']['payment_price'].to_f)
        if total_fee  == 0
          render json: {status: 500, msg: "支付失败,订单金额有误", data: {}} and return
        end
        product_names = trade['data']['units'][0]['name'].to_s+'共'+trade['data']['units'].size.to_s + '件'
        pay_params = {
            body: product_names,
            out_trade_no: trade['data']['identifier'],
            total_fee: total_fee,
            spbill_create_ip: '127.0.0.1',
            notify_url: ALIPAYCONFIG[:alipay][:host] + 'pay/wechats/notify',
            trade_type: 'JSAPI',
            openid: openid
        }
        Rails.logger.info(pay_params)
        res = WxPay::Service.invoke_unifiedorder pay_params.merge({trade_type: 'JSAPI', openid: openid})
        js_pay_params= {
            prepayid: res["prepay_id"],
            noncestr: res["nonce_str"]
        }

        @wx_pay_r = WxPay::Service.generate_js_pay_req js_pay_params

        #flag = {status: 200, msg: "成功", data: {jsapi_ticket: @jsapi_ticket, choose_pay_package: @wx_pay_r}}
        #render json: flag
        render template: 'pay/wechats/mobile_wx_pay'
      end
    rescue Exception => e
      flag = {status: 500, msg: 'wechat_error', data: {error: e}}
      render json: flag
    end

  end


  #pc扫码支付
  def pc_pay
    pay_params = {
        body: '测试商品',
        out_trade_no: 'test009',
        total_fee: 1,
        spbill_create_ip: '127.0.0.1',
        notify_url: ALIPAYCONFIG[:alipay][:host] + 'pay/wechats/notify',
        trade_type: 'NATIVE',
    }

    @res = WxPay::Service.invoke_unifiedorder pay_params
    if @res['result_code'] == 'SUCCESS'
      {status: 200, msg: "成功", data: @res}
    else
      {status: 500, msg: @res['err_code_des'], data: @res}
    end
  end

  #手机非微信浏览器支付
  def mobile_pay
    pay_params = {
        body: '测试商品',
        out_trade_no: 'test005',
        total_fee: 1,
        spbill_create_ip: '127.0.0.1',
        notify_url: ALIPAYCONFIG[:alipay][:host] + 'pay/wechats/notify',
        trade_type: 'MWEB',
        openid: 'openid',
    }
    @res = WxPay::Service.invoke_unifiedorder pay_params
  end


  #手机app支付
  def app_pay
    opt = {appid: WECAHTCONFIG['wechat_app']['appid'],mch_id: WECAHTCONFIG['wechat_app']['mch_id'],key: WECAHTCONFIG['wechat_app']['key']}

    trade = Auction::Trade.detail ({user_id: current_user['id'],trade_id: params[:trade_id]})
    if !trade['data'].present?
      render json: {status: 500, msg: "订单查询失败，稍后重试", data: {}} and return
    end
    total_fee = Auction::Trade.count_wechat_price(trade['data']['payment_price'].to_f)
    if total_fee  == 0
      render json: {status: 500, msg: "支付失败,订单金额有误", data: {}} and return
    end
    product_names = trade['data']['units'][0]['name'].to_s+'共'+trade['data']['units'].size.to_s+'件'
    pay_params = {
        body: product_names,
        out_trade_no: trade['data']['identifier'],
        total_fee: total_fee,
        spbill_create_ip: '127.0.0.1',
        notify_url: ALIPAYCONFIG[:alipay][:host] + 'pay/wechats/notify',
        trade_type: 'APP'

    }
    Rails.logger.info('wechat_app'+"=="*30)
    Rails.logger.info(pay_params)
    res = WxPay::Service.invoke_unifiedorder(pay_params,opt.clone)
    Rails.logger.info(res)
    if res['result_code'] == 'FAIL'
      fail_flag = {status: 500, msg: "失败", data: res}
      render json: fail_flag and return
    end
    app_pay_params= {
        prepayid: res["prepay_id"],
        noncestr: res["nonce_str"]
    }
    res = WxPay::Service.generate_app_pay_req(app_pay_params,opt.clone)
    flag = {status: 200, msg: "成功", data: res}
    render json: flag
  end

  #回调验签
  def notify
    result = Hash.from_xml(request.body.read)["xml"]
    trade = Auction::Trade.detail ({identifier: result['out_trade_no'],type: 1})
    total_fee = Auction::Trade.count_wechat_price(trade['data']['payment_price'].to_f)
    #微信公众号支付商户
    t1 = WxPay::Sign.verify?(result) && total_fee == result['total_fee'].to_i
    #微信app支付商户
    t2 = WxPay::Sign.verify?(result,{key: WECAHTCONFIG['wechat_app']['key']}) && total_fee == result['total_fee'].to_i
    if t1 || t2
      p1 = {'userId': 1,
            'auctionTradeId': trade['data']['trade_id'],
            'outTradeNo': result['out_trade_no'],
            'payType': 2,
            'tradeNo': result['transaction_id'],
            'tradeStatus': 1,
            'notifyId': '',
            'notifyTime': Time.now,
            'gmtPayment': result['time_end'],
            'buyerId': result['appid'],
            'sellerId': result['mch_id'],
            'totalAmount': result['total_fee'].to_i * 0.01,
            'receiptAmount': result['total_fee'].to_i * 0.01,
            'buyerPayAmount': result['settlement_total_fee'],
            'content': result.as_json,
            'buyerLogonId': ''

      }
      t = Auction::Trade.pay_item_callback p1
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end

  end


end

