class AddProductIdToAuctionUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_units, :auction_product_id, :integer, comment: '商品ID'
    add_column :auction_units, :amount, :integer,default: 1, comment: '购买数量'
    add_column :auction_units, :auction_sku_id, :integer, comment: 'skuID'
    add_column :auction_units, :supplier_trade_id, :integer, comment: '供应商订单ID'
    add_column :supplier_trades, :user_id, :integer, comment: '用户ID'
  end
end
