class AddNameToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_column :recoveries, :name, :string, comment: "名称"
  end
end
