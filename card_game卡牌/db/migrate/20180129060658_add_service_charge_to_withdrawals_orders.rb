class AddServiceChargeToWithdrawalsOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :pay_withdrawals_orders, :service_charge, :decimal, precision: 10, scale: 2, default: 0, comment: '手续费'
    add_column :pay_withdrawals_orders, :real_amount, :decimal, precision: 10, scale: 2, default: 0, comment: '提现金额，扣除手续费后的金额'
  end
end
