class AddFromUserIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :from_user_id, :integer, comment: "产生消息 用户id"
  end
end
