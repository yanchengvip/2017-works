class ChangeSupplierTrade < ActiveRecord::Migration[5.1]
  def change
    change_table :supplier_trades do |t|
      t.change :remark, :text
    end
  end
end
