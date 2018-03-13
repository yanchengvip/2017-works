# 执行 rails db:booking_trade_init
namespace :db do
  task booking_trade_init: :environment do
    generate_booking_trade
  end
end

def generate_booking_trade
  BookingTrade.create(account_id: 1, trade_type: 2, mt4_account: 123456,
                      symbol: 'EURUSD.m', digits: 5, volume: 1, booking_price: 1.18654, sl: 1000,
                      tp: 1000, source: 3, dealer_id: 1, dealer_type: 1, status: 0)
  BookingTrade.create(account_id: 1, trade_type: 2, mt4_account: 123456,
                      symbol: 'USDCAD.m', digits: 5, volume: 1, booking_price: 1.26605, sl: 1000,
                      tp: 1000, source: 3, dealer_id: 1, dealer_type: 1, status: 0)

end