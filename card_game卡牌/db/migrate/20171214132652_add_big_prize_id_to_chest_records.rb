class AddBigPrizeIdToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :big_prize_id, :integer, default: 0, comment: '大奖奖品ID,chest_prizes的ID'
  end
end
