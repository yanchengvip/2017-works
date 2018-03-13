# 执行 rails db:user_init
namespace :db do
  task user_init: :environment do
    generate_user
  end
end

def generate_user
  u1 = User.create!(nickname: '吕布', phone: '15810159651', password_digest: '123456')
  u2 = User.create!(nickname: '貂蝉', phone: '15810159652', password_digest: '123456')
  u3 = User.create!(nickname: '阿轲', phone: '15810159653', password_digest: '123456')
  u4 = User.create!(nickname: '项羽', phone: '15810159654', password_digest: '123456')

  d1 = Dealer.create!(name: '模拟盘', dealer_type: 1)
  d2 = Dealer.create!(name: 'wisdom', dealer_type: 2)

  a1 = Account.create!(user_id: u1.id, is_master: true, dealer_id: d1.id, dealer_type: d1.dealer_type, phone: '15810159651', name: '程咬金', certificate: '身份证', certificate_num: '130634199052136')
  a2 = Account.create!(user_id: u2.id, dealer_id: d1.id, dealer_type: d1.dealer_type, phone: '15810159652', name: '王昭君', certificate: '身份证', certificate_num: '130634199052154')
  a3 = Account.create!(user_id: u3.id, dealer_id: d1.id, dealer_type: d1.dealer_type, phone: '15810159653', name: '孙尚香', certificate: '身份证', certificate_num: '130634199052153')
  a4 = Account.create!(user_id: u4.id, is_master: true, dealer_id: d2.id, dealer_type: d2.dealer_type, phone: '15810159654', name: '安其拉', certificate: '身份证', certificate_num: '130634199052152')

  FinancialRecord.create!(account_id: a1.id , dealer_id: d1.id, amount: 100.0, balance: 10000, dealer_type: 1, status: 2)
  FinancialRecord.create!(account_id: a1.id , dealer_id: d1.id, amount: 200.0, balance: 20000, dealer_type: 1, status: 2)
  FinancialRecord.create!(account_id: a2.id , dealer_id: d2.id, amount: 300.0, balance: 30000, dealer_type: 2, status: 3)
  FinancialRecord.create!(account_id: a2.id , dealer_id: d2.id, amount: 400.0, balance: 40000, dealer_type: 2, status: 2)

  Trade.create!(account_id: a1.id, mt4_account: a1.id,
  order_code: "wqq212121", symbol: "czssa", digits: 21, cmd: 0, volume: 212,
  open_time: Time.now, open_price: 212121, sl: 111, tp:222, close_time: "1970-01-01 00:00:00",
  close_price: 222332, commission: 898,profit:47834, source:1,
  dealer_id: d1.id,
  dealer_type: d1.dealer_type
  )

  Trade.create!(account_id: a2.id, mt4_account: a2.id,
  order_code: "wqq212121", symbol: "ewqew", digits: 21, cmd: 0, volume: 212,
  open_time: Time.now, open_price: 212121, sl: 111, tp:222, close_time: "1970-01-01 00:00:00",
  close_price: 222332, commission: 898,profit:47834, source:1,
  dealer_id: d2.id,
  dealer_type: d2.dealer_type
  )

  Trade.create!(account_id: a3.id, mt4_account: a3.id,
  order_code: "wqq212121", symbol: "saas", digits: 21, cmd: 0, volume: 212,
  open_time: Time.now, open_price: 212121, sl: 111, tp:222, close_time: "1970-01-01 00:00:00",
  close_price: 222332, commission: 898,profit:47834, source:1,
  dealer_id: d1.id,
  dealer_type: d1.dealer_type
  )


  BookingTrade.create!(account_id:a1.id,
  trade_type: 1,
  mt4_account: a1.id,
  symbol: "ewqq",
  digits: 67,
  volume: 806,
  deal_price: 8888,
  booking_price: 66565,
  sl: 8787,
  tp: 89,
  source: 3,
  dealer_id: d1.id,
  dealer_type: d1.dealer_type,
  status: 1,
  expire_time: Time.now,
  )

  BookingTrade.create!(account_id:a2.id,
  trade_type: 1,
  mt4_account: a2.id,
  symbol: "cxz",
  digits: 67,
  volume: 806,
  deal_price: 8888,
  booking_price: 66565,
  sl: 8787,
  tp: 89,
  source: 3,
  dealer_id: d1.id,
  dealer_type: d1.dealer_type,
  status: 1,
  expire_time: Time.now,
  )


  BookingTrade.create!(account_id:a3.id,
  trade_type: 1,
  mt4_account: a3.id,
  symbol: "dadsa",
  digits: 67,
  volume: 806,
  deal_price: 8888,
  booking_price: 66565,
  sl: 8787,
  tp: 89,
  source: 3,
  dealer_id: d2.id,
  dealer_type: d2.dealer_type,
  status: 1,
  expire_time: Time.now,
  )
end
