class CreateBoxLuckyWalls < ActiveRecord::Migration[5.0]
  def change
    create_table :box_lucky_walls, comment: '宝箱幸运墙' do |t|
      t.string :title, comment: '奖品墙标题'
      t.string :name, comment: '商品名称'
      t.text :content, comment: '商品内容'
      t.decimal :price, precision: 10, scale: 2, default: 0, comment: '商品价格'
      t.text :promotion_words, comment: '推广文字'
      t.string :image, comment: '商品图片'
      t.integer :lucky_user_num, default: 0, comment: '幸运墙用户数量'
      t.integer :promotion_type,default: 2, comment: '推广类型，1=主推,2:其他'
      t.integer :status, default: 1, comment: '1=启用,2=禁用'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'
      t.timestamps
    end
  end
end
