class AddStatusToBookingTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_trades, :status, :integer, default: 0, comment: '状态: -2= 平台撤单, -1 = 用户撤单,0 = 正常，1 = 成交'
  end
end
