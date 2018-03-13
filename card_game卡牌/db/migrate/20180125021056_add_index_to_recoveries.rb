class AddIndexToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_index :recoveries, [:day, :chest_prize_id], unique: true
  end
end
