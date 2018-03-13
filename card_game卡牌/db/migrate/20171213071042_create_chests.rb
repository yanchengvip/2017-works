class CreateChests < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_boxs, comment: '宝箱表' do |t|
      t.string :name, default: '', comment: '宝箱名称'
      t.datetime :begin_time, comment: '生效开始时间'
      t.datetime :end_time, comment: '生效结束时间'
      t.string :output, default:'', comment: '各阶段产出奖品百分比和产出价值百分比，如[[2,3],[奖品,价值]]'
      t.integer :cant_percent, default: 0, comment: '大奖开启多少百分比，不可产出大奖，如 60'
      t.integer :hours_to_next, default: 0, comment: '大奖开启多少小时后，奖品仍未抽空，自动替换下一宝箱'
      t.text :notice_copy, comment: '全局通知文案'
      t.integer :status, default: 0, comment: '状态，默认0:未开启，1:已开启，2:已停止'
      t.integer :parent_id, default: 0, comment: '由某个id复制过来'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
