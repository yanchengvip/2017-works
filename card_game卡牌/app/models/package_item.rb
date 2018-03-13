class PackageItem < ApplicationRecord
  belongs_to :package
  validates_presence_of :package_id, :prize_range, :win_count
  # validates :price, numericality: {greater_than: 0}
  # validates_numericality_of :price, greater_than_or_equal_to: 0, message: '价格必须为大于0的整数'
  validates_numericality_of :win_count, greater_than_or_equal_to: 0, message: '份数必须为大于0的整数'
  # validates_numericality_of :lottery_times, greater_than: 0, message: '抽奖次数必须为大于0的整数'
end
