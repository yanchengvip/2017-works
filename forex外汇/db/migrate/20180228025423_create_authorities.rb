class CreateAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :authorities,comment: '权限表' do |t|
      t.string :name,comment: '权限名称'
      t.string :action,comment: '具体权限 如user#create'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
