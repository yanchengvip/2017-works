class BookingTradeCheckJob < ApplicationJob
  queue_as :booking_trades

  def perform(booking_trade_id)
    bt = BookingTrade.find(booking_trade_id)
    res = bt.check_price
    unless res
      BookingTradeCheckJob.set(wait: 1.seconds).perform_later(booking_trade_id)
    end
  end
end
