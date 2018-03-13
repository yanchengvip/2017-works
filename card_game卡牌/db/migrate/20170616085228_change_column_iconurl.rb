class ChangeColumnIconurl < ActiveRecord::Migration[5.0]
  def change
    change_column :cards, :icon_url, :string, comment: '缩略图'
    change_column :packages, :icon_url, :string, comment: '缩略图'
  end
end
