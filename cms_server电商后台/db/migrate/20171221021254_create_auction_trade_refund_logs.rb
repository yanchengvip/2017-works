class CreateAuctionTradeRefundLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_trade_refund_logs, comment: '订单退款审核记录表' do |t|
      t.integer :trade_refund_id, default: 0, comment: 'auction_trade_refunds表ID'
      t.integer :editor_id, default: 0, comment: '审核者管理员ID,如果为0则是用户创建'
      t.string :status, comment: '退款状态 audit=待审核、transfer=待财务退款、complete=已退款、cancel=取消'
      t.text :remark, comment: '备注'
      t.boolean :active, comment: "软删", default: true
      t.timestamps
    end
    add_index :auction_trade_refund_logs, :trade_refund_id
  end
end
