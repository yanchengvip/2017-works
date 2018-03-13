class AddDayToRecoveryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :recovery_items, :day, :string
  end
end
