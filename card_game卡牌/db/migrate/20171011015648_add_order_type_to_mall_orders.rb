class AddOrderTypeToMallOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :mall_orders, :order_type, :integer, default: 0, comment: '订单分类，1:平台赛场订单，2:自建赛场订单，3:兑奖阁订单'
    add_column :mall_orders, :glory, :integer, default: 0, comment: '兑换时花费的功勋数'
    remove_column :mall_orders, :mall_product_id
    add_column :mall_orders, :battle_product_id, :integer, default: 0, comment: '商品id'
  end
end
