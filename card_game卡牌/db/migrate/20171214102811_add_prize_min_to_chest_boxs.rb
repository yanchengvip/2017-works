class AddPrizeMinToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :prize_min, :integer, default: 0, comment: '最小商品个数'
    add_column :chest_boxs, :prize_max, :integer, default: 0, comment: '最大商品个数'
    add_column :chest_boxs, :notice_num, :integer, default: 0, comment: '剩余XX个商品时，如大奖还未开出，发出全局通告（集分竞宝、优众APP）'
  end
end
