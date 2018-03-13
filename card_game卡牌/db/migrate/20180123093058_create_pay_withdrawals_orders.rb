class CreatePayWithdrawalsOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :pay_withdrawals_orders, comment: '提现订单表' do |t|
      t.decimal :amount, default: 0, precision: 10, scale: 2, comment: '提现金额'
      t.string :user_id, default: 0, comment: '提现用户ID'
      t.string :status, default: 'transfer', comment: '状态;transfer=待打款，complete=完成，cancel=取消'
      t.integer :admin_id, default: 0, comment: '审批管理员ID'
      t.string :identifier, comment: '订单唯一标识符'
      t.string :alipay_order_id, comment: '支付宝转账单据号'
      t.datetime :pay_date, comment: '支付时间'
      t.text :content, comment: '支付宝返回参数'
      t.string :remark, comment: '备注'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
