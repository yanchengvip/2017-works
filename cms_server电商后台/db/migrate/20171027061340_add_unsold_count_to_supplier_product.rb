class AddUnsoldCountToSupplierProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_products, :unsold_count, :integer, comment: "库存", default: 0
  end
end
