class GluttonEnergyPrize < ApplicationRecord
  belongs_to :glutton_setting

  validates_numericality_of :blood_percent, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'
  validates_numericality_of :energy_percent, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'

  before_validation :set_percents

  private
  def set_percents
    self.blood_percent = self.blood_percent * 0.01
    self.energy_percent = self.energy_percent * 0.01
  end
end
