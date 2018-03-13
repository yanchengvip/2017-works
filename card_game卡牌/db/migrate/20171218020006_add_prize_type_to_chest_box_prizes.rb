class AddPrizeTypeToChestBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_box_prizes, :prize_type, :integer, default: 0, comment: '奖品类型，1:随机，2:指定，3:特定'
    add_column :chest_box_prizes, :min_index,  :integer, default: 0, comment: '特定类型奖品 的最小范围百分比'
    add_column :chest_box_prizes, :max_index,  :integer, default: 0, comment: '特定类型奖品 的最小范围百分比'
  end
end
