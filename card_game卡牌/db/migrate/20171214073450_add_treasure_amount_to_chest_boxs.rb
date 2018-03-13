class AddTreasureAmountToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :treasure_amount, :integer, default: 1, comment: "开宝箱所需要宝符数量"
  end
end
