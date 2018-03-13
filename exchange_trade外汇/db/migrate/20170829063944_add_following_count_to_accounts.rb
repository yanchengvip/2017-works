class AddFollowingCountToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :followers_count, :integer, default: 0, comment: '关注者人数'
  end
end
