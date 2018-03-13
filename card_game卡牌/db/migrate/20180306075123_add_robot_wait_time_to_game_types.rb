class AddRobotWaitTimeToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :robot_wait_time, :integer, default: 0, comment: '机器人进场等待时间，单位：秒'
    add_column :game_types, :robot_count, :integer, default: 0, comment: '机器人个数'
  end
end
