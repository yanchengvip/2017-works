class ExtremeChest < ApplicationRecord
  has_many :extreme_chest_items, -> {where(delete_flag: false)}, dependent: :destroy

  validates_numericality_of :card_count, greater_than: 0, message: '份数必须为大于0的整数'
  # validates :refresh_time, presence: true

  STATUS = {0 => '禁用', 1 => '启用'}

  def save_extreme_chest_items(params)
    params && params.each do |item_param|
      self.extreme_chest_items.create!(item_param.to_hash.slice('gift_type', 'gift_range', 'gift_count'))
    end
  end

  def update_extreme_chest_items(params)
    params && params.each do |item_param|
      if item_param['extreme_chest_item_id'] && (at_item = self.extreme_chest_items.where(id: item_param['extreme_chest_item_id'].to_i).first)
        at_item.update(item_param.to_hash.slice('gift_type', 'gift_range', 'gift_count'))
      elsif item_param['extreme_chest_item_id'].blank?
        self.extreme_chest_items.create!(item_param.to_hash)
      end
    end
  end

end
