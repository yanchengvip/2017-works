class CreateAuctionTradeStatusLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_trade_status_logs, comment: '订单状态记录表' do |t|
      t.integer :table_id, comment: 'auction_trades表ID,supplier_trades表ID'
      t.string :table_type, default: 'Auction::Trade', comment: 'Auction::Trade , Supplier::Trade'
      t.integer :editor_id, default: 0, comment: '审核者管理员ID,如果为0则是用户创建'
      t.string :status, comment: '状态，记录订单的状态'
      t.text :remark, comment: '审核备注'
      t.boolean :active, comment: "软删", default: true

      t.timestamps
    end
    add_index :auction_trade_status_logs, [:table_id, :table_type], name: 'trade_list_table_name_id'
  end
end
