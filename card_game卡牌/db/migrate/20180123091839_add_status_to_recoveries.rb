class AddStatusToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_column :recoveries, :status, :integer, default: 0, comment: "0 启用 1 禁用"
    add_column :recoveries, :sort_index, :integer, default: 0, comment:"大的排前面"
  end
end
