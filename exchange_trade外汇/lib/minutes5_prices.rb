module Minutes5Prices
  extend self
  mongo_url = '127.0.0.1:27017' #mongo数据库链接地址
  mongo_database = 'mt4' #mongo数据名
  minutes5_prices = 'minutes5_prices' #mongo表
  mt4_prices = 'mt4_prices' #mongo表
  client = Mongo::Client.new([mongo_url], :database => mongo_database)
  MIP = client[minutes5_prices]
  MTP = client[mt4_prices]
  def create_minutes5_prices

   doc = MIP.find({}).sort({'date': -1}).first

    if doc
      time = doc['time'].to_time
      date = time.strftime('%Y-%m-%d')
      MTP.find({date: date}).each do |doc|
        p doc["name"]
      end
    end

  end


end