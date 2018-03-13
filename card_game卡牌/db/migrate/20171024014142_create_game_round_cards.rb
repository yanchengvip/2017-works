class CreateGameRoundCards < ActiveRecord::Migration[5.0]
  def change
    create_table :game_round_cards do |t|
      t.integer :round_num, default: 0, comment: '轮次'
      t.integer :card_bag_id, default: 0, comment: '卡包id'
      t.integer :trick_max, default: 0, comment: '本轮计谋上限'
      t.integer :choose_max, default: 0, comment: '可选计谋上限'
      t.integer :attack_ratio, default: 0, comment: '随机计谋比例，攻 的比例'
      t.integer :guard_ratio, default: 0, comment: '随机计谋比例，防 的比例'
      t.integer :control_ratio, default: 0, comment: '随机计谋比例，控 的比例'

      t.integer :table_id, default: 0, comment: '所属表id，(赛场类型id或自荐赛场规则id)'
      t.string :table_type, default: 0, comment: "所属表名，(赛场类型表'GameType'或自荐赛场规则表'SelfGameRule')"
      t.boolean :delete_flag, default: false, comment: '删除标志，0：未删除,1：已删除'

      t.timestamps
    end

    add_index :game_round_cards, :round_num
    add_index :game_round_cards, :table_id
  end
end
