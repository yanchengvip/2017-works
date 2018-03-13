class AddStatusToInviteRelationship < ActiveRecord::Migration[5.0]
  def change
    add_column :invite_relationship, :status, :integer, comment: "财神邀请奖励是否发放 0 未发放， 1 已发放", default: 0
  end
end
