class AddIsCheckCashToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_column :recoveries, :is_check_cash, :boolean, default: false, comment: "是否执行结算任务"
  end
end
