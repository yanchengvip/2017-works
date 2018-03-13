class AddDeleteFlagToPackageItems < ActiveRecord::Migration[5.0]
  def change
    add_column :package_items, :delete_flag, :boolean, default: false, comment: '是否删除 0:未删除，1:已删除'
  end
end
