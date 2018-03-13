class AddExchangeToChestPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_prizes, :exchange, :integer, comment: "献祭百分比 0-100， 0为不可献祭", default: 0
  end
end
