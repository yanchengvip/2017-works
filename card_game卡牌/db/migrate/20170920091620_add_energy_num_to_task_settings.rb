class AddEnergyNumToTaskSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :task_settings, :energy_num, :integer, default: 0, comment: '红包能量数量'
    add_column :task_settings, :receive_user_num, :integer, default: 0, comment: '红包可领取人数'
    add_column :task_settings, :expire_time, :integer, default: 0, comment: '失效时间，以小时为单位'
    add_column :task_settings, :from_win_num, :integer, default: 0, comment: '次数来源,竞赛胜利获得X次'
    add_column :task_settings, :from_fail_num, :integer, default: 0, comment: '次数来源,竞赛失败获得X次'
  end
end
