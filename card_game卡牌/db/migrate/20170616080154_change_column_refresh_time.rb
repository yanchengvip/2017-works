class ChangeColumnRefreshTime < ActiveRecord::Migration[5.0]
  def change
    change_column :extreme_chests, :refresh_time, :string, comment: '礼包刷新时间 每天（00:00）'
  end
end
