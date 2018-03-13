class AddIsOverToBoxLuckyWalls < ActiveRecord::Migration[5.0]
  def change
    add_column :box_lucky_walls, :is_over, :boolean, default: false, comment: '是否已领空'
  end
end
