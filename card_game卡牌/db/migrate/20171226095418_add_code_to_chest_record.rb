class AddCodeToChestRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :code, :string, comment: '唯一标识符'
  end
end
