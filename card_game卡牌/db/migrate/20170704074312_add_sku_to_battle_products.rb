class AddSkuToBattleProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_products, :sku, :string, comment: 'SKU'
    add_column :battle_products, :inventory_place, :string, comment: '库存地'
    add_column :battle_products_copies, :sku, :string, comment: 'SKU'
    add_column :battle_products_copies, :inventory_place, :string, comment: '库存地'
    add_column :mall_products, :sku, :string, comment: 'SKU'
    add_column :mall_products, :inventory_place, :string, comment: '库存地'
  end
end
