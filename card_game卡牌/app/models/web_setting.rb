class WebSetting < ApplicationRecord

  def save_relive_rule rule_param, invite_times, been_invite_times
    self.relive_rule = rule_param
    self.write_invite_code_reward_times = invite_times
    self.been_write_invite_code_reward_times = been_invite_times
    self.save
  end
end
