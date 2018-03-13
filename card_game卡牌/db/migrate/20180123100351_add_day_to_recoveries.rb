class AddDayToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_column :recoveries, :day, :string, comment: "日期"
    add_index :recoveries, :day
  end
end
