class ChangeUserIdToMammonUserCards < ActiveRecord::Migration[5.0]
  def change
    change_column :mammon_user_cards, :user_id, :string, comment: '用户ID'
    change_column :mammon_invite_records, :user_id, :string, comment: '邀请用户ID'
    change_column :mammon_invite_records, :invite_user_id, :string, comment: '被邀请用户ID'
  end
end
