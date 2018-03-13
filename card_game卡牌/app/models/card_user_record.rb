class CardUserRecord < ApplicationRecord
  self.table_name = "card_user_record"
  belongs_to :battle
  ConsumeType = {0 => '战斗中使用', 1 => '转赠消费'}
  GainType = {0 => '购买礼包', 1 => '宝箱', 2 => '战役胜利', 3 => '战役失败', 4 => '赠送', 5 => '赠送回退'}
end
