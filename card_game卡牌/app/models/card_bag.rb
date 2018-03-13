class CardBag < ApplicationRecord
  has_many :card_bag_items, -> {where(delete_flag: false)}, dependent: :destroy
  # has_many :game_round_cards

  validates :name, presence: true


  def save_card_bag_items! item_params
    item_params && item_params.each do |k, v|
      self.card_bag_items.create!(card_id: k, card_num: v)
    end
  end

  def update_card_bag_items! item_params
    item_params && item_params.each do |k, v|
      if card_bag_item = self.card_bag_items.find_by(card_id: k)
        card_bag_item.update_attributes!(card_num: v)
      else
        self.card_bag_items.create!(card_id: k, card_num: v)
      end
    end
  end

  def clear_redis_data
    MsgRecord.apiClient('/card-service-web/card/updateCardBag(', {id: self.id})
  end

  def card_ratiao
    card_bag_items = self.card_bag_items
    attack_ratio = card_bag_items.where(card_id: Card.attacks).sum(:card_num)
    guard_ratio = card_bag_items.where(card_id: Card.guards).sum(:card_num)
    control_ratio = card_bag_items.where(card_id: Card.controls).sum(:card_num)
    return {attack_ratio: attack_ratio, guard_ratio: guard_ratio, control_ratio: control_ratio}
  end

  def check_card_ratio attack_ratio, guard_ratio, control_ratio
    card_ratiao = self.card_ratiao
    res = true
    res = false if card_ratiao[:attack_ratio] > attack_ratio.to_i
    res = false if card_ratiao[:guard_ratio] > guard_ratio.to_i
    res = false if card_ratiao[:control_ratio] > control_ratio.to_i

    return res
  end

end
