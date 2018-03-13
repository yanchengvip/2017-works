class AddIdentifierToSupplierTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_trades, :identifier, :string, comment: '供应商订单号'
  end
end
