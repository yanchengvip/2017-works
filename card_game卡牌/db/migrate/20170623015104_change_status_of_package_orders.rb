class ChangeStatusOfPackageOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :package_orders, :status, :integer, default: 0, comment: '订单状态 '
  end
end
