class GluttonText < ApplicationRecord
  belongs_to :glutton_setting

  validates_numericality_of :blood_percent, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'
  validates :show_text, presence: true

  before_validation :set_percents

  private
  def set_percents
    self.blood_percent = self.blood_percent * 0.01
  end
end
