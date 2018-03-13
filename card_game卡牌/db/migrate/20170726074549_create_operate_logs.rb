class CreateOperateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :operate_logs do |t|
      t.integer :admin_id, default: 0, comment: '用户id'
      t.string :nickname, default: '', comment: '用户登录名称'
      t.string :table_type, default: '', comment: '操作资源'
      t.string :exec_action, default: '', comment: '执行action'
      t.integer :table_id, default: 0, comment: '操作资源id'
      t.string :details, default: 0, comment: '操作详情'

      t.timestamps
    end

    add_index :operate_logs, [:admin_id, :table_type], name: 'admn_operate_index'
  end
end
