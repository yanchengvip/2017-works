class ChangeToSupplierTrades < ActiveRecord::Migration[5.1]
  def change
    change_table :supplier_trades do |t|
      t.change :remark, :text, comment: "备注"
      t.change :ship_at, :datetime, comment: "发货时间"
    end
  end
end
