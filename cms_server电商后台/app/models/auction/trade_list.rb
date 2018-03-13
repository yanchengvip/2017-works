class Auction::TradeList < ApplicationRecord
  belongs_to :auction_trade, class_name: 'Auction::Trade'
  belongs_to :supplier_trade, :class_name => 'Supplier::Trade'
  belongs_to :account, class_name: 'Core::Account', foreign_key: :user_id
  belongs_to :contact, class_name: 'Auction::Contact', foreign_key: :contact_id


  STATUS = {1 => 'auction_trades(未拆分)', 2 => 'auction_trades(已拆分)', 3 => 'supplier_trades的订单'}
end