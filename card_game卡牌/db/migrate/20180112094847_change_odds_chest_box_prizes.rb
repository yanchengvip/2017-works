class ChangeOddsChestBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    change_column :chest_box_prizes, :odds, :decimal, default: 0, precision: 10, scale: 6, comment: '概率'
  end
end
