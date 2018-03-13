# ruby lib/wisdom_ws.rb 执行运行
#gem install eventmachine
#gem install websocket-eventmachine-client
#gem install mongo

require 'eventmachine'
require 'websocket-eventmachine-client'
require 'mongo'
require 'redis'

ws_url = 'ws://165.84.176.206:8193/' #wisdom 推送实时价格的websocket地址
mongo_url = '127.0.0.1:27017' #mongo数据库链接地址
mongo_database = 'mt4' #mongo数据名
mongo_doc = 'mt4_prices' #mongo表

client = Mongo::Client.new([mongo_url], :database => mongo_database)
mt4_prices = client[mongo_doc]

$redis ||= Redis.new(:url => "redis://127.0.0.1:6379/0")
EM.run do

  ws = WebSocket::EventMachine::Client.connect(:uri => ws_url)

  ws.onopen do
    puts "Connected"
  end

  ws.onmessage do |msg, type|
    #puts "Received message: #{msg}" #msg = #NZDJPY,78.55300,78.63300,1504762786
    begin
      msg = msg.delete('#').split(',')
      date = (Time.at msg[3].to_i).strftime("%Y-%m-%d")
      mp = mt4_prices.find('name': msg[0], 'date': date).first
      d = {name: msg[0], bid: msg[1].to_f, ask: msg[2].to_f, dt: (Time.at msg[3].to_i).strftime("%Y-%m-%d %H:%M:%S"), dtt: msg[3].to_i}
      if mp
        mt4_prices.update_one({"name": msg[0], "date": date,ct: Time.now}, {"$push": {data: d}})
      else
        data = {
            name: msg[0],
            date: date,
            data: [d]
        }
        mt4_prices.insert_one(data)
      end

      $redis.lpush(msg[0]+'_BID', msg[1]) #最新卖价
      $redis.lpush(msg[0]+'_ASK', msg[2]) #最新买价
      $redis.ltrim(msg[0]+'_BID', 0, 5)
      $redis.ltrim(msg[0]+'_ASK', 0, 5)
      $redis.hsetnx("#{Time.now.strftime('%Y-%m-%d')}-wisdom-open-price",msg[0],msg[1]) #当天开盘价
      $redis.lpush(msg[0]+'_BID_DAY_MAX',msg[1]) #当天最高价
      $redis.lpush(msg[0]+'_BID_DAY_MIN',msg[1]) #当天最低价
      $redis.sort(msg[0]+'_BID_DAY_MAX',sort: 'desc')
      $redis.sort(msg[0]+'_BID_DAY_MIN')
      $redis.ltrim(msg[0]+'_BID_DAY_MAX', 0, 0)
      $redis.ltrim(msg[0]+'_BID_DAY_MIN', 0, 0)
    rescue Exception => e
      file = File.open("public/ws_mt4_price_error.log", 'a')
      if file
        file.write(e)
        file.close
      end
    end

  end

  ws.onclose do |code, reason|
    puts "Disconnected with status code: #{code}"
  end


end
