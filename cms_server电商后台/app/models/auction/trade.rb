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
# payment_service :: 付款服务，必须为{ 'alipay' => '支付宝','wechat' => '微信','paypal'=>'paypal', 'giveaway' => '赠送' , 'express' => '货到付款' , 'cmbchina' => '招商银行' , 'icbc' => '工商银行' }
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
class Auction::Trade < ApplicationRecord
  include AuctionTradeHelper
  belongs_to :account, foreign_key: :user_id, class_name: 'Core::Account'
  has_many :units, class_name: 'Auction::Unit', foreign_key: 'trade_id'
  belongs_to :contact, class_name: 'Auction::Contact' #收货地址
  belongs_to :invoice_contact, class_name: 'Auction::Contact', foreign_key: 'invoice_contact_id' #邮寄发票地址
  has_many :supplier_trades, :class_name => 'Supplier::Trade', foreign_key: 'auction_trade_id'
  has_many :auction_products, :class_name => "Auction::Product", through: :units
  has_many :auction_skus, :class_name => 'Auction::Sku', through: :units
  has_many :auction_trades_updatings, :class_name => 'Auction::TradesUpdating', foreign_key: 'trade_id'
  has_many  :trade_lists, :class_name => 'Auction::TradeList', foreign_key: 'auction_trade_id'
  has_many  :trade_status_logs, :class_name => 'Auction::TradeStatusLog',  as: :table
  after_save :create_auction_trades_updatings, if: Proc.new { |trade| trade.status_changed? }
  STATUS = {
      "pay" => '待付款',
      "audit" => '待审核',
      "ship" => '待发货',
      "receive" => '待收货',
      "contribute" => '待投稿',
      "complete" => '完成',
      "cancel" => '取消',
      "accept" => '接受',
      "reject" => '拒签',
      "punished" => '惩罚',
      "freezed" => '冻结',
      "blocked" => '通关失败',
      "return" => '退款成功',
      "prepare" => '出库中',
      "returning" => '退款中',
  }

  PAYMENTSERVICE = {'' => '无', 'alipay' => '支付宝', 'wechat' => '微信', 'paypal' => 'paypal', 'giveaway' => '赠送', 'express' => '货到付款', 'cmbchina' => '招商银行', 'icbc' => '工商银行'}
  DELIVERYSERVICE = {
      '' => '无',
      'fedex' => '联邦快递',
      'zjs' => '宅急送',
      'ems' => '邮政EMS',
      'offline' => '线下',
      'pickup' => '自取',
      'sf' => '顺丰速运',
      'yt' => '圆通',
      'scic' => '中加国际快递',
      'bestex' => '百世汇通',
      'zto' => '中通快递',
      'deppon' => '德邦物流',
      'dhl' => 'DHL',
      'yunda' => '韵达',
      'zyzoom' => '增速海淘',
      'ttkdex' => '天天快递',
      'xlobo' => '贝海国际快递',
      'express_au' => '鹰运国际速递'

  }


  #拆单
  def separate_trade params,current_user
    ActiveRecord::Base.transaction do
      self.update_attributes!(status: 'ship',  audit_at: Time.now, audit_editor_id: '')
      self.status_log('ship',params[:remark],current_user)
      units = Auction::Unit.where(trade_id: self.id)
      unit_group = self.units.select("provider_id,sum(price) as price,sum(discount) as discount").group('provider_id')
      if self.payment_service == 'express'
        pay_status = 2
      else
        pay_status = 1
      end
      ActiveRecord::Base.transaction do
        unit_group.each do |ug|
          st = Supplier::Trade.create!(auction_trade_id: self.id, remark: self.remark, status: 'ship',
                                       provider_id: ug.provider_id, price: ug.price, payment_price: ug.discount,
                                       user_id: self.user_id, delivery_phone: self.delivery_phone,pay_status: pay_status)
          st.trade_lists.create!(auction_trade_id:self.id,status: 3,identifier: st.identifier,user_id: st.user_id,contact_id: self.contact_id)
          st.status_log('ship',params[:remark],current_user) #记录status和备注
          units.each do |u|
            if u.provider_id == ug.provider_id
              u.update_attributes!(supplier_trade_id: st.id)
            end
          end
        end
        self.update_attributes!(status: 'ship')
      end
    end
  end



  def status_log(status,remark,current_user)
    self.trade_status_logs.create!(editor_id: current_user.id,status: status,remark: remark)
  end


  private

  def create_auction_trades_updatings
    self.auction_trades_updatings.create(status: self.status)
  end


end
