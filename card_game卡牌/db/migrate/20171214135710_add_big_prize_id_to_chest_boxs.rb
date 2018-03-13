class AddBigPrizeIdToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :big_prize_id, :integer, default: 0, comment: '幸运大奖奖品id'
    add_column :chest_boxs, :big_prize_win, :boolean, default: false, comment: '幸运大奖是否已被抽取，默认0:未抽取，1:已抽取'
  end
end
