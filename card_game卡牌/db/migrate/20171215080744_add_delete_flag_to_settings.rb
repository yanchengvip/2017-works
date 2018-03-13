class AddDeleteFlagToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :delete_flag, :boolean, default: false, comment: '删除标志，默认0:未删除，1:已删除'
  end
end
