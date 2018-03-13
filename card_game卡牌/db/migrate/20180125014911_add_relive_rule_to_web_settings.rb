class AddReliveRuleToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :relive_rule, :text, comment: '复活规则'
    add_column :web_settings, :write_invite_code_reward_times, :integer, default: 0, comment: '填写邀请码奖励次数'
    add_column :web_settings, :been_write_invite_code_reward_times, :integer, default: 0, comment: '被填写邀请码奖励次数'
  end
end
