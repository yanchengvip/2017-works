class Gift < ApplicationRecord
  has_many :gift_items, -> {where(delete_flag: false)}, dependent: :destroy

  validates :name, presence: true

  GIFTTYPE = {1 => '注册赠送'}

  STATUS = {0 => '禁用', 1 => '启用'}

  def save_gift_items(params)
    params && params.each do |item_param|
      self.gift_items.create!(item_param.to_hash.slice('gift_type', 'gift_range', 'count'))
    end
  end

  def update_gift_items(params)
    params && params.each do |item_param|
      if item_param['gift_item_id'] && (at_item = self.gift_items.where(id: item_param['gift_item_id'].to_i).first)
        at_item.update(item_param.to_hash.slice('gift_type', 'gift_range', 'count'))
      elsif item_param['gift_item_id'].blank?
        self.gift_items.create!(item_param.to_hash)
      end
    end
  end

end
