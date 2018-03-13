class AddStatusToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :status, :boolean, default: true, comment: '前台启用 1:启用，0关闭'
    add_column :activities, :receive_hour, :integer, comment: '领取间隔 小时（整数）'
    add_column :activities, :receive_minute, :integer, comment: '领取间隔 分钟（0～59整数）'
  end
end
