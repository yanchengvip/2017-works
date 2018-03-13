class CreateTaskItems < ActiveRecord::Migration[5.0]
  def change
    create_table :task_items do |t|
      t.integer :task_setting_id, default: 0, comment: '任务配置id'
      t.integer :prize_type, default: 0, comment: '奖品类型 1：功勋，2：卡牌'
      t.integer :card_id, default: 0, comment: '当奖品类型为卡牌时，对应的卡牌id'
      t.integer :prize_count, default: 0, comment: '奖品数量'
      t.boolean :delete_flag, default: 0, comment: '删除标志 0：未删除，1：已删除'

      t.timestamps
    end

    add_index :task_items, :task_setting_id
  end
end
