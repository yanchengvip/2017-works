class Auction::TradesController < ApplicationController


  #订单列表
  def index
    #render template: 'auction/trades/index' and return
    p1 = {user_id: current_user['id'], status: params[:status], page_no: params[:page] || 1, page_size: params[:page_size] || 10}

    res = Auction::Trade.list p1
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end


  #订单详情
  def show
    #render template: 'auction/trades/show' and return
    p1 = {user_id: current_user['id'], trade_id: params[:id], supplier_trade_id: params[:supplier_trade_id]}
    res = Auction::Trade.detail p1
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end


  #创建订单
  def create
    params['units'] = JSON.parse(params['units']) if params['units'].is_a?(String)
    res = Auction::Trade.create params.merge!({user_id: current_user['id']})
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end


  # 订单取消
  def cancel
    #render json: {status: 200, msg: '订单取消成功', data: {}} and return
    p1 = {id: params[:id], user_id: current_user['id']}
    res = Auction::Trade.cancel p1
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end

  #  用户收货
  def receive
    #render json: {status: 200, msg: '收货成功', data: {}} and return
    res = Auction::Trade.receive params.merge(user_id: current_user['id'])
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end


  #  查看物流
  def delivery_query
    require 'express/kuaidi100'
    order_code = params[:identifier]

    delivery_service = params[:delivery_service] #|| 'sf'
    logistic_code = params[:delivery_identifier] #|| '964269586065'
    ds = {
        'fedex' => 'lianbangkuaidi', #联邦快递
        'zjs' => 'zhaijisong', #宅急送
        'ems' => 'ems', #邮政EMS
        'sf' => 'shunfeng', #顺丰速运
        'yt' => 'yuantong', #圆通
        #'scic' => '', #中加国际快递
        'bestex' => 'huitongkuaidi', #百世汇通
        'deppon' => 'debangwuliu', #德邦物流
        'dhl' => 'dhl', #DHL
        'yunda' => 'yunda', #韵达
        #'zyzoom' => 'yuantong', #增速海淘
        'ttkdex' => 'tiantian', #天天快递
        #'xlobo' => '', #贝海国际快递
        #'express_au' => 'yuantong', #鹰运国际速递

    }[delivery_service] || delivery_service
    res = Rails.cache.fetch("delivery_#{ds+'_'+logistic_code}",expires: 60*60*2){
      Kuaidi100.query_express(ds, logistic_code)
    }
    if res['returnCode'].present?
      render json: {status: 500, msg: res['message'], data: res} and return
    end
    render json: {status: 200, msg: "成功", data: res} and return
  end


  #确认订单页面的商品清单
  def confirm_products_list
    params['products'] = JSON.parse(params['products']) if params['products'].is_a?(String)
    params.merge!({user_id: current_user['id']})
    res = Auction::Trade.confirm_products_list params
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end


  #订单数量统计
  def amounts
    res = Auction::Trade.amounts params.merge!({user_id: current_user['id']})
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end


  #货到付款
  def express
    res = Auction::Trade.express params.merge({user_id: current_user['id']})
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'], data: res['data'] || []}
  end

  #支付列表
  def pay_list
    res = Auction::Trade.pay_list params
    is_cod = res['data']['is_express'] if res['data'].present?
    @payment_services, device_type = current_browser is_cod
    data = res['data'].merge({payment_services: @payment_services}) if res['data'].present?
    render json: {status: res['comm']['code'].to_i, msg: res['comm']['msg'],
                  data: data}
  end


  private

  #请求浏览器 device_type: 设备类型: 1=PC浏览器,2=手机非微信浏览器,3=手机微信浏览器
  def current_browser is_cod
    payment_service = []
    device_type = 0
    browser = Browser.new(request.user_agent, accept_language: "en-us")
    if !browser.device.mobile? && Setting.pay['pay_list']['alipay']['use']
      payment_service.push({name: '支付宝', payment_service: 'alipay'})
      device_type = 1
    end
    if browser.device.mobile? && !browser.wechat? && Setting.pay['pay_list']['alipay']['use']
      payment_service.push({name: '支付宝', payment_service: 'alipay'})
      device_type = 2
    end
    if browser.device.mobile? && browser.wechat? && Setting.pay['pay_list']['wechat']['use']
      payment_service.push({name: '微信', payment_service: 'wechat'})
      device_type = 3
    end
    if Setting.pay['pay_list']['paypal']['use']
      payment_service.push({name: 'paypal', payment_service: 'paypal'})
    end
    if is_cod && Setting.pay['pay_list']['express']['use']
      payment_service.push({name: '货到付款', payment_service: 'express'})
    end
    return payment_service, device_type
  end

end
