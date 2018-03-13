class ChestBoxPrize < ApplicationRecord

  belongs_to :chest_box
  belongs_to :chest_prize

  LEVEL = {2 => '稀有', 1 => '幸运大奖', 3 => '普通', 4 => '大奖'}
  THREE_LEVEL = {2 => '稀有', 3 => '普通', 4 => '大奖'}
  # 奖品类型，1:随机，2:指定，3:特定, 4:3次必中实物, 5: app注册实物，6:app注册虚拟，7:h5随机，8:h5固定 9: 固定现金宝箱 10: 随机现金宝箱

  def odds_cal
    return rand(10000 * 100) < self.odds * 10000
  end

  before_save :check_big_prize
  def check_big_prize
    chest_box = ChestBox.find_by(id: self.chest_box_id)
    if !chest_box.delete_flag
      if self.level == 1 && !ChestBoxPrize.active.where(chest_box_id: self.chest_box_id, level: 1).blank?
        raise '每个宝箱幸运大奖只能有一个！'
      end
    end
  end

end
