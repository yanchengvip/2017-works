class AddT114ToBoxLuckyWalls < ActiveRecord::Migration[5.0]
  def change
    add_column :box_lucky_walls, :t114, :string, default: '', comment: '主推商品图片切图114X114'
    add_column :box_lucky_walls, :t267, :string, default: '', comment: '主推商品图片切图267X267'
  end
end
