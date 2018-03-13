class ExtremeChestItem < ApplicationRecord
  belongs_to :extreme_chest

  validates_presence_of :extreme_chest_id, :gift_range, :gift_type
  validates_numericality_of :gift_count, greater_than: 0, message: '份数必须为大于0的整数'
end
