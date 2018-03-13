class AddForageToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :forage, :integer, default: 0, comment: '卡牌消耗的粮草（同一卡牌所有战役所有轮次相同）'
  end
end
