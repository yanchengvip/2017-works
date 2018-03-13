class Mammon::UserWinning < ApplicationRecord
  belongs_to :mammon_period, :class_name => 'Mammon::Period',foreign_key: 'period_id'
  belongs_to :mammon_period_item, :class_name => 'Mammon::PeriodItem'
  belongs_to :user


end
