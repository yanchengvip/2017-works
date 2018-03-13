class AddReceivedPriceToSupplierTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_trades, :received_price, :decimal, comment: '已收金额'
  end
end
