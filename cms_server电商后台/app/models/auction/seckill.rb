class Auction::Seckill < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :product

  PLAY = {1 => '第一场', 2 => '第二场', 3 => '第三场'}
  before_save :cal_begin_end_time

  def self.change_active_price
    Auction::Seckill.where("date = ? and active = true", Date.today.to_s).each do |s|
      s.change_active_price
    end
  end

  def change_active_price
    self.product.update(seckill_price: discount, seckill_begin_time: begin_time, seckill_end_time: end_time) if Time.now < Time.parse(begin_time)
  end

  def cal_begin_end_time
    time = Time.parse self.date
    time += 8 * 3600
    time += 3600 * 4 * (self.play - 1)
    self.begin_time = time.strftime("%F %T")
    self.end_time = (time + 4 * 3600).strftime("%F %T")
  end
end
