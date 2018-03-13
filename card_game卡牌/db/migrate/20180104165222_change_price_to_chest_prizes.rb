class ChangePriceToChestPrizes < ActiveRecord::Migration[5.0]
  def change
    change_column :chest_prizes, :price, :float, comment: "奖品价值", default: 0
  end
end
