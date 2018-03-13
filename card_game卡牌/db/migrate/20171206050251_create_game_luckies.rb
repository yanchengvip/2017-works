class CreateGameLuckies < ActiveRecord::Migration[5.0]
  def change
    create_table :game_luckies do |t|
      t.string :product_name, default: '', comment: '中奖商品名称（备用）'
      t.string :thumbnail, default: '', comment: '中奖商品图片'
      t.decimal :price, precision: 10, scale: 2, default: 0, comment: '中奖商品价格'
      t.string :headimg, default: '', comment: '用户头像'
      t.string :nickname, default: '', comment: '用户昵称'
      t.integer :win_type, default: 0, comment: '幸运儿中奖类型，默认0:后台配置，1:真实中奖'
      t.string :remark, default: '', comment: '备注'
      t.boolean :delete_flag, default: 0, comment: '删除标志，默认0:未删除，1:删除'

      t.timestamps
    end
  end
end
