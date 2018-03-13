class ChangeUserIdForPackageOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :package_orders, :user_id, :string, default: '', comment: '用户id'
  end
end
