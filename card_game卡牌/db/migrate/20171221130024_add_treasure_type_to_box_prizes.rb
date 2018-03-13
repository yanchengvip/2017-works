class AddTreasureTypeToBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :box_prizes, :treasure_type, :integer, default: 1, comment: '1=赠送付费宝箱符,2=赠送免费宝箱符'
    add_column :box_prize_records, :free_treasure_amount, :integer,default: 0,comment: '赠送免费宝箱符数量'
  end
end
