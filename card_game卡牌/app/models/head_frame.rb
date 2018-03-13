class HeadFrame < ApplicationRecord
  self.table_name = 'crm_head_frame'

  UNLOCKCT = {-2 => '注册赠送', -1 => '能量兑换'}

  before_save :set_unlock_level
  def set_unlock_level
    self.unlock_level = self.unlock_condition
    self.unlock_condition = 0 if self.unlock_condition > 0
  end

  def clear_redis_data
    MsgRecord.apiClient('/card-service-web/headFrame/clearUserHeadFrame', {})
  end

end
