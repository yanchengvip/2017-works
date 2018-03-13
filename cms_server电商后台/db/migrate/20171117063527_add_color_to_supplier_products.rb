class AddColorToSupplierProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_products, :color, :string
  end
end
