class AddAreaToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :area, :string, comment: "地区"
  end
end
