class Mammon::PeriodItem < ApplicationRecord
  belongs_to :period

  #中奖等级
  PrizeNum = {
      0 => '特等奖',
      1 => '一等奖',
      2 => '二等奖',
      3 => '三等奖'
  }

end
