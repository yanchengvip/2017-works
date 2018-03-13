class AddFollowTradeIdToBookingTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_trades, :follow_trade_id, :integer, comment: '被跟随订单的trades表的ID'
  end
end
