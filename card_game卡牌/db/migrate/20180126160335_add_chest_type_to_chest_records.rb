class AddChestTypeToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :chest_type, :integer, comment: "宝箱类型", default: 0
  end
end
