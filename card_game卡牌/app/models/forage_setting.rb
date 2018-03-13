class ForageSetting < ApplicationRecord
  validates_numericality_of :base_forage, greater_than_or_equal_to: 0, message: '用户基础粮草必须为大于0的整数'
  validates_numericality_of :turn_second, greater_than_or_equal_to: 0, message: '用户每轮每X秒增长粮草必须为大于0的整数'
  validates_numericality_of :turn_forage_incr, greater_than_or_equal_to: 0, message: '用户每轮每X秒增长粮草数量必须为大于0的整数'
  validates_numericality_of :last_turn_second, greater_than_or_equal_to: 0, message: '最后一轮最后X秒狂暴增长必须为大于0的整数'
  validates_numericality_of :last_turn_per_second, greater_than_or_equal_to: 0, message: '最后一轮狂暴时间内每X秒增长粮草必须为大于0的整数'
  validates_numericality_of :last_turn_forage_incr, greater_than_or_equal_to: 0, message: '最后一轮狂暴时间内每X秒增长粮草数量必须为大于0的整数'
  validates_numericality_of :max_forage, greater_than_or_equal_to: 0, message: '用户每场战役粮草值上限必须为大于0的整数'


end
