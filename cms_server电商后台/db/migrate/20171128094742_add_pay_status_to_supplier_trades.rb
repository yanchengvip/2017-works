class AddPayStatusToSupplierTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_trades, :pay_status, :string, default: 2, comment: '支付状态 1 =>已支付 2=>未支付 3=>部分付款'
    add_column :pay_items, :supplier_trade_no, :string, comment: '商家订单号'
    add_column :pay_items, :remark, :string, comment: '备注'
  end
end
