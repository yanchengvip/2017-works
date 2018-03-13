class ChangeMammonPeriodsDayInviteMaxAmount < ActiveRecord::Migration[5.0]
  def change
    remove_column :mammon_periods, :day_invite_max_amount
    add_column :mammon_periods, :invite_max_amount, :decimal, default: 0, precision: 10, scale: 2, comment: '邀请好友分享金额上限'
  end
end
