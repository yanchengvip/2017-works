class Setting < ApplicationRecord
  audited
  validates :var, uniqueness: { scope: :delete_flag, message: '键不能重复'}

  def self.value(var)
    Rails.cache.fetch("setting_key_#{var}", expires_in: 60){
      Setting.where(var: var).first&.value
    }
  end

  # active_type
  ACTIVE_USER_TYPE = {1 => '按日', 2 => '按周'}

  def push_to_java
    MsgRecord.apiClient('/card-service-web/admin/refreshSetting')
  end

end
