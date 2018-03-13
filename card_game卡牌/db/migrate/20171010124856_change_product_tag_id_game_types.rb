class ChangeProductTagIdGameTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :game_types, :product_tag_id

  end
end
