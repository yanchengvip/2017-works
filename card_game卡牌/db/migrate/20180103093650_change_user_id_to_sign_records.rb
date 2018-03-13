class ChangeUserIdToSignRecords < ActiveRecord::Migration[5.0]
  def change
    change_column :sign_records, :user_id, :string
  end
end
