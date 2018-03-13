class Auction::VoucherTrade < Base
  has_many :score_items, as: :table
  self.table_name = "auction_voucher_trades"
  belongs_to :event
  after_create :create_out_trade_no
  STATUS = {0 => "未支付", 1 => '已支付'}

  #创建out_trade_no
  def create_out_trade_no
    self.out_trade_no = "L#{Time.now.strftime('%Y%m%d%H%M%S')}#{self.id.to_s.rjust(15, '0')}"
    self.save!
  end

  # def paypal_url params
  #   payment = ::Payment.new(
  #           {
  # :intent =>  "sale",
  # :payer =>  {
  #   :payment_method =>  "paypal" },
  # :redirect_urls => {
  #   :return_url => "http://localhost:3000/payment/execute",
  #   :cancel_url => "http://localhost:3000/" },
  # :transactions =>  [{
  #   :item_list => {
  #     :items => [{
  #       :name => "item",
  #       :sku => "item",
  #       :price => "15",
  #       :currency => "USD",
  #       :quantity => 1 }]},
  #   :amount =>  {
  #     :total =>  "15",
  #     :currency =>  "USD" },
  #   :description =>  "voucher_trade##{self.id}" }]}


  #   # {
  #   #   :intent =>  "sale",
  #   #   :payer =>  {
  #   #     :payment_method =>  "paypal" },
  #   #   :redirect_urls => {
  #   #     :return_url => params[:return_url],
  #   #     :cancel_url => params[:return_url],
  #   #   :transactions =>  [{
  #   #     :item_list => {
  #   #       :items => [{
  #   #         :name => self.event.name,
  #   #         :sku => '优惠券',
  #   #         :price => Auction::ExchangeRate.exchange(self.payment_price, Setting.pay["pay_list"]["paypal"]["currency"]),
  #   #         :currency => Setting.pay["pay_list"]["paypal"]["currency"],
  #   #         :quantity => 1 }
  #   #         ]},
  #   #     :amount =>  {
  #   #       :total =>  Auction::ExchangeRate.exchange(self.payment_price, Setting.pay["pay_list"]["paypal"]["currency"]),
  #   #       :currency =>  Setting.pay["pay_list"]["paypal"]["currency"] },
  #   #     :description =>  "voucher_trade#{self.id}"}]}}
  #       )
  #   payment.create

  #   payment.approval_url
  # end

  #支付宝生成订单支付URL
  def alipay_url(params)
    return "/" if self.out_trade_no.blank?
    params = {
      return_url: params["return_url"],
      notify_url: "#{Setting.hosts}/api/auction/voucher_trades/alipay_notify",
      biz_content: {subject: "优惠券", out_trade_no: "#{self.out_trade_no}",total_amount: self.payment_price, product_code: "QUICK_WAP_PAY"}
    }
    url = MyAlipay::Wap::Service.create_alipay_trade_wap_pay_url params
  end

  #支付宝异步通知接口
  def alipay_notify(params)
    is_verify = MyAlipay::Wap::Notify.wap_notify params.clone
    if is_verify
      #验签成功处理
      res = false
      self.with_lock do
        if self.status == 0
          self.status = 1
          self.payment_service = "alipay"
          self.payment_identifier = params["trade_no"]
          self.save!
          res = true
        end
      end
      if res
        self.score_items.create!(amount: self.cal_recharge_amount, out_trade_no: self.out_trade_no, user_id: self.user_id)
        self.create_voucher
      end
      return true
    else
      return false
      #验签失败处理
    end
  end

  #通知微积分服务增加用户积分
  def notify_drp_service
    params = {account: self.user.account.phone, channel: 1, amount: self.cal_recharge_amount, timestamp: Time.now.strftime("%Y%m%d%H%M%S%L"), out_trade_no: self.out_trade_no}
    url = SYSCONFIG["drp_service"]["host"]+"/drp-service-web/recharge/rechargeService"
    params[:sign] = Digest::MD5.hexdigest("account=#{params[:account]}&channel=1&amount=#{params[:amount]}").upcase
    rsa_string = Auction::VoucherTrade.rsa_sign(params.to_json).gsub("\n", "")
    res = false
    self.with_lock do
      if self.status == 1
        response = JSON.parse(Timeout::timeout(30){ Mechanize.new.post(url, {param: rsa_string}).body })
        p response
        if response["execResult"] == true && response["execData"] && response["execData"]["tradeNo"]
          self.drp_server_trade_no = response["execData"]["tradeNo"]
          self.status = 2
          self.save!
          res = true
        end
      end
    end
    return res
  end

  #生成优惠券
  def create_voucher
    arr = []
    self.amount.to_i.times{ arr<< {event_id: self.event_id, editor_id: 1, user_id: self.user_id, remark: "voucher_trade_#{self.id}"} }
    Auction::Voucher.create!(arr)
    self.is_created_voucher = true
    self.save
  end

  #计算增加的积分数值
  def cal_recharge_amount
    self.event.micro_amount.to_i
    # unless Auction::VoucherTrade.where("id < ?", self.id).exists?
    #   (self.amount * SYSCONFIG[:voucher_trade][:recharge] + SYSCONFIG[:voucher_trade][:first_single_presentation]).to_f
    # else
    #   (self.amount * SYSCONFIG[:voucher_trade][:recharge]).to_f
    # end
  end

  #微积分服务签名
  def self.rsa_sign(rsa_string)
    pri = OpenSSL::PKey::RSA.new(Base64.decode64(SYSCONFIG["drp_service"]["rsa_private_key"]))
    sign = ""
    rsa_string.each_chunk(117){|str| sign += pri.private_encrypt(str)}
    signature = Base64.encode64(sign)
    return signature
  end


end
