# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "log/cron_log.log"


#同步wisdom外汇产品数据
# every "* * * * *" do
#   runner "Api::WisdomMt4Price.sync_wisdom_product"
# end

# #同步wisdom新闻数据
# every "*/5 * * * *" do
#   runner "Article.crawler_from_wisdom"
# end

# #同步wisdom订单数据
# every "* * * * *" do
#   runner "Api::WisdomMt4Trade.sync_mt4_trade"
# end

# #同步wisdom用户数据
# every "*/10 * * * *" do
#   runner "Api::WisdomMt4User.sync_wisdom_account"
# end

# #同步mt5新闻数据
# every "*/30 * * * *" do
#   runner "Article.crawler_from_mt5"
# end

# #价格提醒通知
# every "*/2 * * * *" do
#   runner "ExchangeProductPriceNotice.check_up_price_notice"
# end



