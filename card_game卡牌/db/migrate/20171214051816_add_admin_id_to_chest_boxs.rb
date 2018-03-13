class AddAdminIdToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :admin_id, :integer, default: 0, comment: '创建人id'
  end
end
