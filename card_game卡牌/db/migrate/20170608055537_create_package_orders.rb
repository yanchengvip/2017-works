class CreatePackageOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :package_orders do |t|
      t.string :code, comment: '订单编号'
      t.integer :package_id, default: 0, comment: '礼包id'
      t.integer :user_id, default: 0, comment: '购买用户'
      t.integer :total_count, default: 0, comment: '购买数量'
      t.decimal :total_price, default: 0, comment: '总价格'
      t.boolean :status, default: false, comment: '领取状态 0:未领取，1已领取'
      t.string :request_ip, comment: '用户ip'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'

      t.timestamps
    end

    add_index :package_orders, :package_id
    add_index :package_orders, :user_id
  end
end
