class AddRewardTimesToTaskSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :task_settings, :reward_times, :integer, default: 0, comment: '奖励次数限制 -1:不限次数，0:每日一次，1:1次, 2：2次，以此类推'
    add_column :task_settings, :thumbnail, :string, default: '', comment: '任务图标地址'
  end
end
