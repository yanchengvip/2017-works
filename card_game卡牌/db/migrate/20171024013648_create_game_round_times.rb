class CreateGameRoundTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :game_round_times do |t|
      t.integer :round_num, default: 0, comment: '轮次'
      t.integer :round_time, default: 0, comment: '本轮时间，单位：秒'
      t.integer :table_id, default: 0, comment: '所属表id，(赛场规则id或自荐赛场规则id)'
      t.string :table_type, default: 0, comment: "所属表名，(赛场规则表'GameRule'或自荐赛场规则表'SelfGameRule')"
      t.boolean :delete_flag, default: false, comment: '删除标志，0：未删除,1：已删除'

      t.timestamps
    end

    add_index :game_round_times, :round_num
    add_index :game_round_times, :table_id
  end
end
