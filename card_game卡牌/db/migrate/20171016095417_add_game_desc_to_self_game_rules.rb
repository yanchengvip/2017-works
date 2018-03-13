class AddGameDescToSelfGameRules < ActiveRecord::Migration[5.0]
  def change
    add_column :self_game_rules, :game_desc, :text, comment: '自建赛场规则说明'
  end
end
