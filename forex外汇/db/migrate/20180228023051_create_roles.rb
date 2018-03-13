class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles, comment: '角色表' do |t|
      t.string :name, comment: '角色名称'
      t.text :content, comment: '备注'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
