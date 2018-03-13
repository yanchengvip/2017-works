class GluttonDeadPrize < ApplicationRecord
  belongs_to :glutton_setting
  validates :roundth, presence: true
  validates_numericality_of :last_blood_energy, greater_than_or_equal_to: 0, message: '最后击杀饕餮的用户获得的能量必须为大于等于0的整数'
  validates_numericality_of :max_blood_energy, greater_than_or_equal_to: 0, message: '对饕餮伤害最大的用户获得的能量必须为大于等于0的整数'
end
