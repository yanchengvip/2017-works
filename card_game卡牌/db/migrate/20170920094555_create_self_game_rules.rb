class CreateSelfGameRules < ActiveRecord::Migration[5.0]
  def change
    create_table :self_game_rules do |t|
      t.string :name, default: '', comment: '规则名称'
      t.integer :round_num, default: 0, comment: '竞赛轮数'
      t.integer :round_time, default: 0, comment: '每轮时间（单位：分）'

      t.integer :play_init_cd, comment: '初始出牌cd时间'
      t.integer :play_min_cd, comment: '出牌最小cd时间'
      t.integer :play_max_cd, comment: '出牌最大cd时间'

      t.integer :deal_init_cd, comment: '初始发牌cd时间'
      t.integer :deal_min_cd, comment: '发牌最小cd时间'
      t.integer :deal_max_cd, comment: '发牌最大cd时间'

      t.integer :init_card_num, default: 0, comment: '入场发牌张数'
      t.integer :card_max_num, default: 0, comment: '拥有卡牌上限'

      t.decimal :play_cd_inc, precision: 5, scale: 1, default: 0, comment: '出牌cd时间增益'
      # 【用户拥有密钥百分比（%）— 33.33%】× play_cd_inc
      t.integer :round_baofu_num, default: 0, comment: '每轮结束奖励的宝符数量'
      t.integer :loser_baofu_min_num, default: 0, comment: '竞赛结束给竞赛失败用户奖励的宝符最小数量'
      t.integer :loser_baofu_max_num, default: 0, comment: '竞赛结束给竞赛失败用户奖励的宝符最大数量'

      t.integer :card_bag_id, default: 0, comment: '卡包id'

      t.boolean :delete_flag, default: false, comment: '删除标志，默认为0 1:已删除，0:未删除'

      t.timestamps
    end

    add_index :self_game_rules, :name
    add_index :self_game_rules, :card_bag_id
  end
end
