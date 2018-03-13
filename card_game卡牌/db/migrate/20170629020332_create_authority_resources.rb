class CreateAuthorityResources < ActiveRecord::Migration[5.0]
  def change
    create_table :authority_resources do |t|
      t.string :name, comment: '资源名称'
      t.integer :status, default: 1, comment: '资源状态,1:启用,2:禁用'
      t.string :model_n, comment: 'Model名称'
      t.string :action_n, comment: 'Action名称'
      t.string :desc
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
