class AddNameToExtremeChests < ActiveRecord::Migration[5.0]
  def change
    add_column :extreme_chests, :name, :string, comment: '名称'
  end
end
