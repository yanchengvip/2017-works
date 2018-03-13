class AddPriceToMallOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :mall_orders, :consignee,:string,comment: '收货人'
    add_column :mall_orders, :mobile,:string,comment: '收货人电话'
    add_column :mall_orders, :shipping_address,:string,comment: '发货地址'
    add_column :mall_orders, :logistics_company,:string,comment: '物流公司'
    add_column :mall_orders, :logistics_num,:string,comment: '物流单号'
    add_column :mall_orders, :market_price, :decimal, default: 0, precision: 10, scale: 2, comment: '市场价格'
    add_column :mall_orders, :cost_price, :decimal, default: 0, precision: 10, scale: 2, comment: '成本价格'
    add_column :mall_orders, :thumbnail, :string, comment: '商品缩略图'
  end
end
