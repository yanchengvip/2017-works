class ActivityItem < ApplicationRecord
  belongs_to :activity

  validates_presence_of :activity_id, :gift_range
  validates_numericality_of :gift_count, greater_than: 0, message: '份数必须为大于0的整数'
end
