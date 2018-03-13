class Mt4::FxPricesController < ApplicationController

  #外汇品种实时价格

  def create

    fx_prices = [{"ask": '1001.00',bid: '1000.00',"Symbol": 'XAUUSD100'}]
    ActionCable.server.broadcast(
        'fx_price_channel', # 这是流的名字，要跟在 stream_from 定义的保持一致
        title: '货币的价格行情',
        datas: fx_prices
    )

    fx_prices.each do |fx|
      symbol = fx[:Symbol]
      $redis.lpush(symbol+'_ASK', fx[:ask].to_f) #最新卖价
      $redis.lpush(symbol+'_BID', fx[:bid].to_f) #最新买价
      $redis.ltrim(symbol+'_BID', 0, 5)
      $redis.ltrim(symbol+'_ASK', 0, 5)

      $redis.lpush(symbol+'_BID_DAY_MAX',fx[:bid].to_f)
      $redis.lpush(symbol+'_BID_DAY_MIN',fx[:bid].to_f)
      $redis.sort(symbol+'_BID_DAY_MAX',sort: 'desc')
      $redis.sort(symbol+'_BID_DAY_MIN')
      $redis.ltrim(symbol+'_BID_DAY_MAX', 0, 0)#当天最高价
      $redis.ltrim(symbol+'_BID_DAY_MIN', 0, 0)#当天最低价
    end

  end
end
