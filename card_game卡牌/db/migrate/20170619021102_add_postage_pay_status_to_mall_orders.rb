class AddPostagePayStatusToMallOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :mall_orders, :postage_pay_status, :integer, default: 0, comment: '邮费支付状态；0:待支付,1:已支付'
    add_column :mall_orders, :postage_pay_time, :datetime, comment: '邮费支付时间'
    add_column :mall_orders, :shipping_time, :datetime, comment: '发货时间'
  end
end
