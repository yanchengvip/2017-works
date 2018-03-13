#统计类型statistic_type;1:mall_orders统计,2:兑换记录统计,3:card统计
class CsvFile < ApplicationRecord
  belongs_to :user
end
