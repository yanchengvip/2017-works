##
# = 拍卖 交易 表
#
# == Fields
#
# original_id :: 原始交易ID
# user_id :: 用户ID
# item_id :: 单件ID
# contact_id :: 地址ID
# link_id :: 链接ID
# click_id :: 点击ID
# status :: 状态，必须为{ 'pay' => '待付款', 'audit' => '待审核', 'ship' => '待发货', 'receive' => '待收货', 'complete' => '完成', 'cancel' => '取消', 'punished' => '惩罚', 'freezed' => '冻结', 'prepare' => '备货中', 'contribute' => '待投稿', 'accept' => '接受', 'reject' => '拒绝', 'return' => '返还' }
# price :: 价格
# payment_price :: 付款价格
# comment :: 留言
# identifier :: 编号
# point :: 积分
# percent :: 折扣
# note_id :: 投稿ID
# circle_id :: 投稿ID
# bonus :: 奖励积分
# punishment :: 惩罚积分
# payment_service :: 付款服务，必须为{ 'alipay' => '支付宝','wechat' => '微信','paypal' =>'paypal', 'giveaway' => '赠送' , 'express' => '货到付款' , 'cmbchina' => '招商银行' , 'icbc' => '工商银行' }
# payment_identifier :: 付款标识
# pay_at :: 确认支付方式时间
# pay_editor_id :: 确认支付方式编辑人员ID
# delivery_service :: 快递服务，必须为{ 'fedex' => '联邦快递', 'zjs' => '宅急送', 'ems' => '邮政EMS', 'offline' => '线下', 'pickup' => '自取', 'sf' => '顺丰速运' }之一
# delivery_identifier :: 快递编号
# delivery_time :: 快递时间，必须为{ 'workday' => '工作日', 'playday' => '休息日', 'all' => '皆可' }之一
# invoice_type :: 发票类型，必须为{ 'personal' => '个人', 'company' => '公司' }之一
# invoice_title :: 发票抬头
# invoice_content :: 发票内容，必须为{ 'present' => '礼品', 'detail' => '商品明细' }之一
# editor_id :: 编辑ID
# client :: 客户端类型, 必须为 %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat] 之一
# audit_editor_id :: 审核编辑ID
# audit_at :: 审核时间
# prepare_editor_id :: 备货编辑ID
# prepare_at :: 备货时间
# ship_editor_id :: 发货编辑ID
# ship_at :: 发货时间
# freeze_editor_id :: 冻结编辑ID
# freeze_at :: 冻结时间
# receipt_editor_id :: 收款编辑ID
# receipted_at :: 收款时间
# receipted? :: 收款？
# delivery_received_at :: 快递收货时间
# invoice_delivery_service :: 发票快递服务，取值同“快递服务”
# invoice_delivery_identifier :: 发票快递编号
# invoice_remark :: 发票备注
# package_from :: 包装发送人
# package_to :: 包装接收人
# package_content :: 包装内容
# whisper_style :: 密语风格
# whisper_from :: 密语发送人
# whisper_to :: 密语接收人
# whisper_content :: 密语内容
# remark :: 备注
# texas_holdem_code :: 德州扑克活动码
# shop_id :: 店铺ID
# shop_identifier :: 商场单号
# guide_id :: 导购ID
# active? :: 有效？
#
# == Indexes
#
class Auction::Trade < JavaServerRecord
  def self.options params
    post("auction/products/options", params)
  end

  STATUS = {
      "pay" => '待付款',
      "audit" => '待审核',
      "ship" => '待发货',
      "receive" => '待收货',
      "contribute" => '待投稿',
      "complete" => '完成',
      "cancel" => '取消',
      "accept" => '接受',
      "reject" => '拒绝',
      "punished" => '惩罚',
      "freezed" => '冻结',
      "blocked" => '通关失败',
      "return" => '返还',
      "prepare" => '出库中'
  }

  PAYMENTSERVICE = {'alipay' => '支付宝', 'wechat' => '微信', 'paypal' => 'paypal', 'giveaway' => '赠送', 'express' => '货到付款', 'cmbchina' => '招商银行', 'icbc' => '工商银行'}


  #订单列表-java
  def self.list params
    post("/order-service/auction/trades/list", params)
  end

  #订单详情-java
  def self.detail params
    post("/order-service/auction/trades/detail", params)
  end

  #取消
  def self.cancel params
    post("/order-service/auction/trades/cancel", params)
  end

  #订单创建
  def self.create params
    post('/order-service/auction/trades/create', params)
  end

  #数量
  def self.amounts params
    post('/order-service/auction/trades/status', params)
  end

  def self.confirm_products_list params
    post('/order-service/auction/trades/confirmProductsList', params)

  end


  #收货
  def self.receive params
    post('/order-service/auction/trades/receive', params)
  end

  #支付列表
  def self.pay_list params
    post('/order-service/auction/trades/pay', params)
  end

  #货到付款
  def self.express params
    post('/order-service/auction/trades/express', params)
  end


  #支付回调
  def self.pay_item_callback params
    post('/order-service/callback/callback', params)
  end

  #支付宝支付
  def self.alipay params
    Rails.logger.info('alipay'+'==='*10)
    #device_type 设备类型1=PC浏览器,2=手机非微信浏览器
    device_type = params[:device_type]
    begin
      #支付宝支付优惠1%，微信支付优惠2%
      params1 ={
          return_url: params[:return_url],
          notify_url: ALIPAYCONFIG[:alipay][:host] + 'pay/alipays/notify',
          biz_content: {subject: params[:name],
                        out_trade_no: params[:out_trade_no],
                        total_amount: params[:price]}
      }
      Rails.logger.info(params1)
      case device_type.to_i
        when 1
          #pc支付
          url = MyAlipay::Page::Service.create_alipay_trade_page_pay_url params1
        when 2
          #手机非微信浏览器
          url = MyAlipay::Wap::Service.create_alipay_trade_wap_pay_url params1
        when 3
          #支付宝app支付
          url = MyAlipay::Mobile::Service.create_alipay_trade_app_pay_url params1
        else
          url = MyAlipay::Page::Service.create_alipay_trade_page_pay_url params1
      end
      return {status: 200, msg: "支付成功", data: {url: url}}
    rescue Exception => e
      return {status: 500, msg: "支付失败", data: {}}
    end
  end

  #境外手机支付
  def self.alipay_global params
    begin
      params1 = {
          service: 'create_forex_trade_wap',
          partner: ALIPAYCONFIG[:alipay_global][:partner],
          _input_charset: 'UTF-8',
          #sign_type: 'MD5',#不参与签名
          notify_url: ALIPAYCONFIG[:alipay][:host] + 'pay/alipays/notify',
          return_url: params[:return_url],
          subject: params[:name],
          body: params[:name],
          out_trade_no: params[:out_trade_no],
          currency: Setting.pay['currency'],
          total_fee: params[:price],
          product_code: 'NEW_WAP_OVERSEAS_SELLER'
      }
      str = MyAlipay::Utils.params_to_string params1.stringify_keys
      sign_hash = MyAlipay::Sign::MD5.sign(ALIPAYCONFIG[:alipay_global][:private_key], str)
      url = "https://mapi.alipay.com/gateway.do?#{sign_hash[:sign_str]}&sign=#{sign_hash[:sign]}"
      return {status: 200, msg: "支付成功", data: {url: url}}
    rescue Exception => e
      return {status: 500, msg: "支付失败", data: {}}
    end

  end


  def self.count_alipay_price price
    (price.to_f * (Setting.pay['alipay_discount'].to_f)).to_i
  end

  def self.count_wechat_price price
    (price.to_f * (Setting.pay['wechat_discount'].to_f)).to_i * 100
  end

end
