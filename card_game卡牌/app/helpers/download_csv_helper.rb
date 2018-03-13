module DownloadCsvHelper
  def statistic_type_name type
     name = ''
     case type.to_i
       when 1
         name = '兑换订单统计'
       when 2
         name = '中奖订单统计'
       when 3
         name = '战役卡牌统计'
      when 4
        name = "用户信息"
      when 5
        name = "用户卡牌使用统计"
      when 6
        name = "用户充值微积分"   
     end

    return name
  end
end
