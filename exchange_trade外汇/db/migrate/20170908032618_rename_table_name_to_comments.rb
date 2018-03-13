class RenameTableNameToComments < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :table_name, :table_type
    rename_column :detections, :table_name, :table_type
  end
end
