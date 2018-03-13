class ChangePrizeTypeToMammonInviteRecords < ActiveRecord::Migration[5.0]
  def change
    change_column :mammon_invite_records, :prize_type, :string, comment: '奖励类型'
  end
end
