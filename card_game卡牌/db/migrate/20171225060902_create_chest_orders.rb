class CreateChestOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_orders do |t|
      t.string :code, default: '', comment: '订单号'
      t.string :huyi_code, default: '', comment: '互亿无线订单号'
      t.integer :recharge_type, default: 0, comment: '充值类型，1：手机充值，2：Q币充值'
      t.integer :status, default: 0, comment: '订单状态，默认0：待审核，-1:取消充值，1:充值中，2:充值成功，3:充值失败'
      t.datetime :order_time, comment: '下单时间'
      t.string :number, default: '', comment: '充值号码（手机号或QQ号）'
      t.integer :amount, default: 0, comment: '充值金额或Q币数量'
      t.string :memo, default: '', comment: '说明（充值失败原因）'
      t.string :user_id, default: 0, comment: '用户id'
      t.integer :admin_id, default: 0, comment: '审核人id'
      t.integer :chest_record_id, default: 0, comment: '宝箱开启记录id'
      t.integer :channel, default: 0, comment: '充值渠道，默认0:宝箱'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end

    # add_index :chest_orders, :code, unique: true
    add_index :chest_orders, :user_id
  end
end
