class RenameCoulumnIconUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :cards, :icon_url, :thumbnail
    rename_column :packages, :icon_url, :thumbnail
  end
end
