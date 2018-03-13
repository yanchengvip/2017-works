class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, comment: '角色名称'
      t.string :en_name, comment: '角色英文名称'
      t.integer :status, default: 1, comment: '状态 -1:删除,0:禁用,1:正常'
      t.string :remark, comment: '备注'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
