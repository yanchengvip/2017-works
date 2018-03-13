class CreateAuctionTradeLists < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_trade_lists, comment: 'auction_trades和supplier_trades的索引表' do |t|
      t.integer :auction_trade_id, default: 0, comment: 'auction_trades表ID'
      t.integer :supplier_trade_id, default: 0, comment: 'supplier_trades表ID'
      t.integer :status, default: 1, comment: '1=auction_trades订单(未拆分),2=auction_trades订单(已拆分)，3=supplier_trades订单'
      t.boolean :active, comment: "软删", default: true
      t.timestamps
    end
    add_index :auction_trade_lists, [:auction_trade_id, :supplier_trade_id], name: 'trade_list_table_name_id'
  end

end
