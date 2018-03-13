module Mammon::PeriodsHelper

  def mammon_prize_name num
    res = ''
    case num
    when 0
      res = '特等奖'
    when 1
      res = '一等奖'
    when 2
      res = '二等奖'
    when 3
      res = '三等奖'
    end

    res
  end

  def period_prize_count num
    res = ''
    case num
    when 0
      res = 1
    when 1
      res = 9
    when 2
      res = 90
    when 3
      res = 900
    end

    res
  end
end
