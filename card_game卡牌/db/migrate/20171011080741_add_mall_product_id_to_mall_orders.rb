class AddMallProductIdToMallOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :mall_orders, :mall_product_id, :integer, default: 0, comment: '原来对应的兑奖阁商品id，以后不用'
  end
end
