class AddBuyerLogonIdToPayItems < ActiveRecord::Migration[5.1]
  def change
    add_column :pay_items, :buyer_logon_id, :string,comment: '买家支付宝账号'
    add_column :pay_items, :auction_trade_id, :integer,comment: '订单auction_trades表ID'
    add_column :pay_items, :created_at, :datetime
    add_column :pay_items, :updated_at, :datetime
  end
end
