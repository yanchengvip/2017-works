class GiftItem < ApplicationRecord
  belongs_to :gift

  validates_presence_of :gift_id, :gift_range, :gift_type
  validates_numericality_of :count, greater_than: 0, message: '份数必须为大于0的整数'
end
