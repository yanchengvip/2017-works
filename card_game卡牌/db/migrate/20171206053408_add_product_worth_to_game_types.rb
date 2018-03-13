class AddProductWorthToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :product_worth, :decimal, precision: 10, scale: 2, default: 0, comment: '对应商品价值'
  end
end
