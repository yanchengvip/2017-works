class CreateEnergyOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :energy_orders do |t|
      t.string :code, comment: '订单编号'
      t.integer :energy_product_id, default: 0, comment: '能量商品id'
      t.integer :status, default: 0, comment: '订单状态 0:未到账，1:已到账'
      t.integer :user_id, default: 0, comment: '购买用户id'
      t.integer :energy_count, default: 0, comment: '本次购买商品的能量点数'
      t.integer :give_energy_count, default: 0, comment: '本次购买赠送的能量点数'

      t.timestamps
    end

    add_index :energy_orders, :energy_product_id
    add_index :energy_orders, :user_id
  end
end
