##
# = 拍卖 单位 表
#
# == Fields
#
# trade_id :: 交易ID
# item_id :: 单件ID
# circle_id :: 圈物ID
# multibuy_id :: 连拍ID
# discount :: 折扣价
# price :: 市场价
# percent :: 折扣
# level_percent :: 用户等级折扣
# guide_percent :: 店铺折扣
# point :: 积分
# bonus :: 奖励积分
# contributed? :: 投稿？
# returned? :: 退货？
# status :: 状态，必须为{ '' => '未申请', 'audit' => '待审核', 'receive' => '待收货', 'complete' => '完成', 'cancel' => '取消', 'freezed' => '冻结', 'transfer' => '待退款', }之一
# request_at :: 请求时间
# audit_editor_id :: 审核编辑
# audit_at :: 审核时间
# receive_editor_id :: 收货编辑
# receive_at :: 收货时间
# transfer_editor_id :: 退款编辑
# transfer_at :: 退款时间
# freeze_editor_id :: 冻结编辑
# freeze_at :: 冻结时间
# return_phone :: 退款电话
# return_province :: 退款省份
# return_city :: 退款城市
# return_bank :: 退款银行
# return_branch :: 退款支行
# return_name :: 退款人
# return_account :: 退款帐号
# return_reason :: 退货原因
# amount_received :: 收款金额
# amount_received_at :: 收款时间
# amount_receive_editor_id :: 收款编辑
# amount_returned :: 现金退款金额
# amount_balance_returned :: 余额退款金额
# amount_returned_at :: 退款时间
# amount_return_editor_id :: 退款编辑
# remark :: 退货备注
# prepared? :: 已备货？
# prepare_remark :: 备货备注
#
# == Indexes
#
# trade_id
#
class Auction::Unit < ApplicationRecord
  belongs_to :trade, :class_name => "Auction::Trade"
  belongs_to :supplier_trade, :class_name => 'Supplier::Trade'
  belongs_to :voucher
  belongs_to :auction_product, :class_name => 'Auction::Product'
  belongs_to :supplier_product, :class_name => 'Supplier::Product',foreign_key: 'auction_product_id'
  belongs_to :auction_sku, :class_name => 'Auction::Sku'
  belongs_to :product, class_name: 'Auction::Product',foreign_key: :auction_product_id
  belongs_to :item
  belongs_to :provider, class_name: 'Supplier::Provider'
  has_many :unit_refund_logs, :class_name => 'Auction::UnitRefundLog',foreign_key: :unit_id

  STATUS = {
      '' => '正常',#无退货
      'audit' => '待审核',#退货流程
      'receive' => '待收货',#退货流程
      'transfer' => '待退款',
      'complete' => '完成', #退货完成
      'cancel' => '取消',
      'freezed' => '冻结',
  }

  def returnit!(options = {}) #:nodoc: all
    return false if self.returned?
    ActiveRecord::Base.transaction do
      self.update_attributes!(options.merge(:returned => true))
      self.voucher.update_attributes!(:trade_id => nil) if self.voucher
    end
    return true
  end
end
