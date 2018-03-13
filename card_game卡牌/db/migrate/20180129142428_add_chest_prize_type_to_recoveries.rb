class AddChestPrizeTypeToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_column :recoveries, :chest_prize_type, :integer, default: 0, comment: "回收奖品类型"
  end
end
