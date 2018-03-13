class AddFreeTreasureAmountToBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :box_prizes, :free_treasure_amount, :integer,default: 0,comment: '赠送免费宝箱符数量'
  end
end
