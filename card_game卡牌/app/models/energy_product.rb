class EnergyProduct < ApplicationRecord
  has_many :energy_product_gifts, -> {where(delete_flag: false)}, dependent: :destroy

  validates :name, presence: true
  validates :thumbnail, presence: true

  scope :not_onshelf, -> {where(status: 0)}
  scope :is_onshelf, -> {where(status: 1)}

  SHELFSTATUS = {-1 => '已下架', 0 => '未上架', 1 => '已上架'}

  def save_energy_product_gifts! params
    params && params.each do |item_param|
      self.energy_product_gifts.create!(item_param.to_hash.slice('buy_times', 'energy_count', 'show_text'))
    end
  end

  def update_energy_product_gifts!(params)
    params && params.each do |item_param|
      if item_param['id'] && (at_gift = self.energy_product_gifts.where(id: item_param['id'].to_i).first)
        at_gift.update(item_param.to_hash.slice('buy_times', 'energy_count', 'show_text'))
      elsif item_param['id'].blank?
        self.energy_product_gifts.create!(item_param.to_hash)
      end
    end
  end
end
