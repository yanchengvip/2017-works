class GluttonLevel < ApplicationRecord
  self.table_name = 'crm_glutton_level'
  has_many :level_gifts, -> {where(delete_flag: false)}, dependent: :destroy
  validates :level, uniqueness: { scope: :delete_flag, message: "等级不能重复"}

  def self.levels
    self.active.map{|gl| ["饕餮#{gl.level}级", gl.level]}
  end

  def save_week_gifts!(week_params)
    self.level_gifts.where(gift_type: 0).update_all(delete_flag: true)
    week_params && week_params.each do |param|
      self.level_gifts.create!(param.permit!.slice('gifts_id', 'gifts_num').merge(gift_type: 0))
    end
  end

  def save_up_gifts!(up_params)
    self.level_gifts.where(gift_type: 1).update_all(delete_flag: true)
    up_params && up_params.each do |param|
      self.level_gifts.create!(param.permit!.slice('gifts_id', 'gifts_num').merge(gift_type: 1))
    end
  end

end
