class AddPrizeLimitToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :prize_limit, :string, default: '', comment: '各类型奖品的数量限制，{1: xx, 2: xx, 3: xx, 4: xx}'
  end
end
