class BoxPrizeRecord < ApplicationRecord
  belongs_to :user
  belongs_to :box_prize
  belongs_to :box_prize_code

  validates :code, presence: true

  TREASURETYPE = {1=> '赠送付费宝箱符',2=> '赠送免费宝箱符'}
end
