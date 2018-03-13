class AddMemoToChestPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_prizes, :memo, :text, comment: '现金券说明'
  end
end
