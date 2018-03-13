class AddThumbnailToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :thumbnail, :string, default: '', comment: '缩略图'
  end
end
