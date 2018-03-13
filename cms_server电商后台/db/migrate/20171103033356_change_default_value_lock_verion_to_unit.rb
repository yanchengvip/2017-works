class ChangeDefaultValueLockVerionToUnit < ActiveRecord::Migration[5.1]
  def change
    change_column :auction_units, :lock_version, :integer, default: 0
  end
end
