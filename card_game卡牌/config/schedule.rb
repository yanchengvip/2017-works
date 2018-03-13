set :output, "log/cron_log.log"
#根据秒杀活动改价
every "1 * * * *" do
  runner "ChestBox.close"
end

every "* * * * *" do
  runner "ChestOrder.confirm_status!"
end


every "*/5 * * * *" do
  runner "ChestRecordTmp.syn!"
end

every "*/2 * * * *" do
  runner "ChestRecordTmp.overdue_to_redis"
end

every "* * * * *" do
  runner "Recharge.confirm_status!"
end

every "1 0 * * *" do
  runner "Recovery.open_recovery"
end

every "1 22 * * *" do
  runner "Recovery.check_cash"
end

every "* * * * *" do
  runner "Promotion::RedPackageRule.auto_trigger_red_package!"
end

#每天21：00开启财神
every "0 * * * *" do
  runner "Mammon::Period.open_period"
end

#每天20：00自动执行卡牌攻击
every 1.day,at: '20:00' do
  runner "Mammon::UserCard.auto_use_card"
end

# #每天：20自动执行卡牌攻击
# every "20 * * * *" do
#   runner "Mammon::UserCard.auto_use_card"
# end

#每天9自动发送消息推送
every 1.day,at: '09:00' do
  runner "Mammon::Period.send_jpush"
end

every "*/2 * * * *" do
  runner "InviteRelationship.sny_relation"
end


