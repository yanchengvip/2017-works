class AddIdentifierToAuctionTradeLists < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_trade_lists, :identifier, :string, comment: '订单号'
    add_column :auction_trade_lists, :user_id, :integer, comment: '用户ID'
    add_column :auction_trade_lists, :contact_id, :integer, comment: '地址ID'
  end
end
