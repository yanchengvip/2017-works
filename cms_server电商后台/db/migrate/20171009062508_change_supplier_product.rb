class ChangeSupplierProduct < ActiveRecord::Migration[5.1]
  def change
    change_table :supplier_products do |t|
      t.change :remark, :text
      t.change :remark2, :text
    end
  end
end
