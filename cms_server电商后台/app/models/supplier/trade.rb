class Supplier::Trade < ApplicationRecord
  scope :own, ->(provider_id) { where(provider_id: provider_id) }
  belongs_to :auction_trade, :class_name => "Auction::Trade", foreign_key: 'auction_trade_id'
  belongs_to :account, foreign_key: :user_id, class_name: 'Core::Account'
  belongs_to :provider, class_name: 'Supplier::Provider'
  has_many :units, -> { includes :product }, :class_name => "Auction::Unit", foreign_key: 'supplier_trade_id'
  has_many :auction_products, :class_name => "Auction::Product", through: :units
  has_many :auction_skus, :class_name => 'Auction::Sku', through: :units
  has_many :trade_lists, :class_name => 'Auction::TradeList', foreign_key: 'supplier_trade_id'
  has_many :trade_status_logs, :class_name => 'Auction::TradeStatusLog', as: :table
  has_many :trade_refunds, :class_name => 'Auction::TradeRefund', foreign_key: 'supplier_trade_id'
  has_one :contact, class_name: 'Auction::Contact', foreign_key: 'contact_id', through: :auction_trade #收货地址
  has_one :invoice_contact, class_name: 'Auction::Contact', foreign_key: 'invoice_contact_id', through: :auction_trade #邮寄发票地址
  # belongs_to :contact, :class_name => "Auction::Unit"
  after_create :create_supplier_trade_identifier


  DELIVERY_SERVICES = [
      {:name => 'fedex', :title => '联邦快递', :url => 'https://www.fedex.com/fedextrack/?action=track&cntry_code=cn'},
      {:name => 'sf', :title => '顺丰速运', :url => 'http://sf-express.com/cn/sc/'},
      {:name => 'zjs', :title => '宅急送', :url => 'http://www.zjs.com.cn/WS_Business/WS_Business_GoodsTrack.aspx'},
      {:name => 'ems', :title => '邮政EMS', :search_name => 'ems', :url => 'http://www.ems.com.cn/mailtracking/you_jian_cha_xun.html'},
      {:name => 'offline', :title => '线下'},
      {:name => 'pickup', :title => '自取'},
      {:name => 'yt', :title => '圆通', :search_name => 'yuantong'},
      {:name => 'scic', :title => '中加国际快递'},
      {:name => 'bestex', :title => '百世汇通', :search_name => 'huitong'},
      {:name => 'zto', :title => '中通快递', :search_name => 'zhongtong'},
      {:name => 'deppon', :title => '德邦物流'},
      {:name => 'dhl', :title => 'DHL'},
      {:name => 'yunda', :title => '韵达', :search_name => 'yunda'},
      {:name => 'zyzoom', :title => '增速海淘'},
      {:name => 'ttkdex', :title => '天天快递', :search_name => 'tiantian'},
      {:name => 'xlobo', :title => '贝海国际快递'},
      {:name => 'express_au', :title => '鹰运国际速递'},
  ]

  STATUS = {
      "ship" => '待发货',
      "receive" => '待收货',
      "complete" => '完成',
      "cancel" => '取消',
      "accept" => '接受',
      "reject" => '拒签',
      "freezed" => '冻结',
      "prepare" => '出库中',
      "returning" => '退款中',
      "return" => '退款成功',

  }
  PAYSTATUS = {
      '1' => "已支付",
      '2' => "未支付",
      '3' => "部分付款"
  }


  def status_log(status, remark, current_user)
    self.trade_status_logs.create!(editor_id: current_user.id,  status: status, remark: remark)
  end

  private

  def create_supplier_trade_identifier
    code = Time.now.strftime('%Y%m%d%H%M%S') + ((('1'..'9').to_a + ('A'..'Z').to_a)).sample(3).join('') + self.id.to_s
    self.update_attributes!(identifier: code)
  end
end
