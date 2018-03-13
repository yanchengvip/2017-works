class AddEventIdToChestPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_prizes, :event_id, :integer, default: 0, comment: 'prize_type=6时，对应的券id'
  end
end
