class AddIsRecoveryToChestRecordItems < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_record_items, :is_recovery, :boolean, comment: "是否回收", default: false
    add_index :chest_record_items, :is_recovery
  end
end
