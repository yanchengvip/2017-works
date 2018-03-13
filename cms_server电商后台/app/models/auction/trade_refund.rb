class Auction::TradeRefund < ApplicationRecord
  belongs_to :account, foreign_key: :user_id, class_name: 'Core::Account'
  belongs_to :editor, class_name: 'Manage::Editor', foreign_key: 'editor_id'
  belongs_to :supplier_trade, :class_name => 'Supplier::Trade',foreign_key: 'supplier_trade_id'
  belongs_to :auction_trade, :class_name => 'Auction::Trade',foreign_key: 'auction_trade_id'
  has_many :trade_refund_logs, :class_name => 'Auction::TradeRefundLog',foreign_key: 'trade_refund_id'

  #退款状态
  STATUS = {'audit' => '待供应商审核', 'transfer' => '待财务退款', 'complete' => '已退款','cancel' => '取消'}
end
