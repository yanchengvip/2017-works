json.execResult true
json.execMsg '签到奖励设置列表'
json.execErrCode 200
json.execDatas do
  json.total_days @sgs.length #后台设置连续奖励总天数
  json.user_days @running_days #用户连续登录的天数
  json.sign_days do
    json.array! @sgs do |s|
      json.running_days s.running_days #连续登录天数
      json.amount s.amount #奖励免费宝箱符数量
      json.is_main s.is_main #是否突出显示
      json.gift_type s.gift_type
    end
  end

end