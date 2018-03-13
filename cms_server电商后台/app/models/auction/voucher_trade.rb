class Auction::VoucherTrade < ActiveRecord::Base
  has_many :score_items, as: :table
  self.table_name  = :auction_voucher_trades
  # attr_accessible :active, :amount, :event_id, :payment_identifier, :payment_price, :payment_service, :payment_time, :status, :user_id
  belongs_to :user
  belongs_to :event
  after_create :create_out_trade_no
  STATUS = {0 => "未支付", 1 => '已支付'}
  ISCREATEDVOUCHER = {false => "未发券", true => "已发券"}

  #创建out_trade_no
  def create_out_trade_no
    self.out_trade_no = "L#{Time.now.strftime('%Y%m%d%H%M%S')}#{self.id.to_s.rjust(15, '0')}"
    self.save!
  end

  #支付宝生成订单支付URL
  def alipay_url
    return "/" if self.out_trade_no.blank?
    params = {
      return_url: "http://#{HOSTS['dynamic']}/auction/voucher_trades/#{self.id}/alipay_return",
      notify_url: "http://#{HOSTS['dynamic']}/auction/voucher_trades/alipay_notify",
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




end
