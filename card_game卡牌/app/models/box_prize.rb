class BoxPrize < ApplicationRecord
  has_many :box_prize_codes,dependent: :destroy



  #生成兑奖码
  def generate_codes num

    if self.prize_type == 1
      num.to_i.times do
        self.box_prize_codes.create(num: 1)
      end

    end

    if self.prize_type == 2
      self.box_prize_codes.create(num: num)
    end

  end

  #追加兑奖码
  def add_codes num
    if self.prize_type == 1
      num.to_i.times do
        self.box_prize_codes.create(num: 1)
      end

    end

    if self.prize_type == 2
      bpc = self.box_prize_codes.first
      bpc.update_attributes(num: bpc.num + num.to_i)
    end
  end
end
