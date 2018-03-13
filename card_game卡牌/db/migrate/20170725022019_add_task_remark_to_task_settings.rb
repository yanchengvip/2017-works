class AddTaskRemarkToTaskSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :task_settings, :task_remark, :text, comment: '任务说明'
  end
end
