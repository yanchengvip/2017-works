class CreateMallOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :mall_orders, comment: '兑换订单表' do |t|
      t.integer :user_id, comment: '购买用户ID'
      t.integer :mall_product_id,comment: '通兑商城商品表ID'
      t.integer :address_id, comment: '收货地址ID'
      t.string :order_code, comment: '订单号'
      t.string :product_name, comment: '商品名称'
      t.integer :pay_type,default: 0,comment: '支付方式：0:无支付,1:微集券支付,2:微集分支付'
      t.integer :micro_ticket, default: 0, comment: '微集券支付金额'
      t.integer :micro_score, default: 0, comment: '微集分支付金额'
      t.decimal :postage, default: 0, precision: 10, scale: 2, comment: '邮费'
      t.integer :status, default: 0, comment: '0:未发货,1:已发货'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
