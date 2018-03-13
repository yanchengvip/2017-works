class CardBagItem < ApplicationRecord
  belongs_to :card_bag
  belongs_to :card

  validates :card_id, uniqueness: { scope: :card_bag_id, message: "同一卡包不能有重复卡牌记录！" }
end
