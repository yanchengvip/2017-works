class AddWinnerBxfToGameRules < ActiveRecord::Migration[5.0]
  def change
    add_column :game_rules, :winner_bxf, :integer, default: 0, comment: '竞赛胜利奖励宝箱符个数'
    add_column :game_rules, :loser_bxf, :integer, default: 0, comment: '竞赛失败奖励宝箱符个数'

    add_column :self_game_rules, :winner_bxf, :integer, default: 0, comment: '竞赛胜利奖励宝箱符个数'
    add_column :self_game_rules, :loser_bxf, :integer, default: 0, comment: '竞赛失败奖励宝箱符个数'
  end
end
