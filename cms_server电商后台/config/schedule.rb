set :output, "log/cron_log.log"
#根据秒杀活动改价
every "50 * * * *" do
  runner "Auction::Seckill.change_active_price"
end

#获取中行 汇率数据
every "* * * * *" do
  runner "Auction::ExchangeRate.get_exchange_rate_from_bankofchina"
end

#定时上下架轮播
every "* * * * *" do
  runner "Auction::PicAd.auto_shelf"
end


#定时上下架专题
every "* * * * *" do
  runner "Auction::Theme.auto_shelf"
end
