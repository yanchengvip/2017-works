class AddPrizeTypeToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :prize_type, :integer, default:0, comment: "1包含实物 2 不包含实物"
  end
end
