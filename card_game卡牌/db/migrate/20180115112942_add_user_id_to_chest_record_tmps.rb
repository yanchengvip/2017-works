class AddUserIdToChestRecordTmps < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_record_tmps, :user_id, :string
    add_index :chest_record_tmps, [:user_id], unique: true
  end
end
