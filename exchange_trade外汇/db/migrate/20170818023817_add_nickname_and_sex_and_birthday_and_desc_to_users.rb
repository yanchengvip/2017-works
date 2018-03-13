class AddNicknameAndSexAndBirthdayAndDescToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sex, :integer, comment: "性别 0 未知 1男 2女", default: 0
    add_column :users, :birthday, :datetime, comment: "生日"
    add_column :users, :desc, :string, comment: "简介", limit: 50
  end
end
