class AddSortNumToBoxLuckyWalls < ActiveRecord::Migration[5.0]
  def change
    add_column :box_lucky_walls, :sort_num, :integer, default: 0, comment: '排序'
  end
end
