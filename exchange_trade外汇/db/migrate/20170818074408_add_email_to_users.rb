class AddEmailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string, comment: "邮箱"
  end
end
