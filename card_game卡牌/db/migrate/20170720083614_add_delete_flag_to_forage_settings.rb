class AddDeleteFlagToForageSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :forage_settings, :delete_flag, :boolean, default: false, comment: '删除状态，0:未删除，1:已删除'
  end
end
