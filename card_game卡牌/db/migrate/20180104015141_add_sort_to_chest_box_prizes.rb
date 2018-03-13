class AddSortToChestBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_box_prizes, :sort_num, :integer, default: 0, comment: '排序'
  end
end
