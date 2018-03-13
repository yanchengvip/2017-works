class AddPointShowRoundToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :point_show_round, :integer, default: 0, comment: '倒数第几轮显示赛点'
    add_column :web_settings, :point_show_num, :integer, default: 0, comment: '赛点显示个数'
    add_column :web_settings, :point_quit_time, :integer, default: 0, comment: '竞赛剩余时间小于X秒，退出赛点'
  end
end
