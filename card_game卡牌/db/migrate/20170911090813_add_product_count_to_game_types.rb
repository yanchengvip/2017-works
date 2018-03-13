class AddProductCountToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :product_count, :integer, default: 0, comment: '随机选择的商品数量，当product_config_type为 1 时有用'
  end
end
