class AddChange < ActiveRecord::Migration[5.0]
  def change
    change_column :mammon_periods, :invite_reward, :integer, comment: '邀请奖励'
    change_column :mammon_periods, :been_invite_reg_reward, :integer, comment: '被邀请奖励'

  end
end
