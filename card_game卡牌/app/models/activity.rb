class Activity < ApplicationRecord
  has_many :activity_items, -> {where(delete_flag: false)}, dependent: :destroy
  # has_many :cards, through: :activity_cards

  validates :receive_hour, numericality: {less_than_or_equal_to: 24}
  # {greater_than: 0, less_than_or_equal_to: 24}
  validates :receive_minute, numericality: {less_than_or_equal_to: 60}

  def save_activity_items(params)
    params.each do |item_param|
      self.activity_items.create!(item_param.to_hash.slice('gift_type', 'gift_range', 'gift_count'))
    end
  end

  def update_activity_items(params)
    params && params.each do |item_param|
      if item_param['activity_item_id'] && (at_item = self.activity_items.where(id: item_param['activity_item_id'].to_i).first)
        at_item.update(item_param.to_hash.slice('gift_type', 'gift_range', 'gift_count'))
      elsif item_param['activity_item_id'].blank?
        self.activity_items.create!(item_param.to_hash)
      end
    end
  end

end
