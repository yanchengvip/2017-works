class AddGameProductTagIdToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :game_product_tag_id, :integer, default: 0, comment: '平台赛场商品分类id'
  end
end
