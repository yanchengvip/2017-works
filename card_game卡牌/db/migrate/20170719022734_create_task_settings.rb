class CreateTaskSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :task_settings do |t|
      t.integer :task_type, default: 0, comment: '任务类型 1：邀请好友，2:参战有奖，3:战场首次出击，4:更换个性头像，5:绑定微信'
      t.string :task_name, default: '', comment: '任务名称'
      t.integer :need_count, default: 0, comment: '需要完成多少次（或邀请多少人）获得奖励'
      t.boolean :status, default: 0, comment: '启用状态 0：禁用，1：启用'
      t.boolean :delete_flag, default: 0, comment: '删除标志 0：未删除，1：已删除'

      t.timestamps
    end

    add_index :task_settings, :task_type
  end
end
