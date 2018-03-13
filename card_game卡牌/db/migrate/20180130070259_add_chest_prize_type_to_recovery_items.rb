class AddChestPrizeTypeToRecoveryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :recovery_items, :chest_prize_type, :integer, comment: "奖品类型ID", default: 0
  end
end
