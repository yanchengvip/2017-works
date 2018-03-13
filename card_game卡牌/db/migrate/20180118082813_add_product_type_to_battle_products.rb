class AddProductTypeToBattleProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_products, :product_type, :integer, default: 0, comment: '商品类型，默认0:普通商品；1:手机充值；2:入场券；3:兑奖券；4:宝箱符'
    add_column :battle_products, :product_num, :integer, default: 1, comment: '商品数量，默认1'
  end
end
