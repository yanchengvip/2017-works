class AddMarginToTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :trades, :margin, :decimal, precision: 16, scale: 6, comment: '订单的保证金'
  end
end
