class AddSkuIdToRetailCarts < ActiveRecord::Migration[5.1]
  def change
    add_column :retail_carts, :sku_id, :integer, default: 0, comment: '所选择的商品sku'
  end
end
