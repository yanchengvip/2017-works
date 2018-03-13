class CreateAuctionTradeRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_trade_refunds, comment: '订单退款单表' do |t|
      t.integer :auction_trade_id, default: 0, comment: 'auction_trades表ID'
      t.integer :supplier_trade_id, default: 0, comment: 'supplier_trades表ID'
      t.string :auction_trade_identifier, comment: 'auction_trades表订单号'
      t.string :supplier_trade_identifier, comment: 'supplier_trades表订单号'
      t.integer :editor_id, comment: '管理员ID,如果为0则是用户创建'
      t.integer :user_id, comment: '用户ID'
      t.text :remark, comment: '退款说明'
      t.string :status,  comment: '退款状态 audit=待审核、transfer=待财务退款、complete=已退款、cancel=取消'
      t.decimal :amount, precision: 12, scale: 2, default: 0, comment: '申请退款金额'
      t.decimal :return_amount, precision: 12, scale: 2, default: 0, comment: '实际退款金额'
      t.boolean :active, comment: "软删", default: true
      t.timestamps
    end
    add_index :auction_trade_refunds, [:auction_trade_id, :supplier_trade_id], name: 'trade_refunds_trade_id'
    add_index :auction_trade_refunds, :user_id
  end
end
