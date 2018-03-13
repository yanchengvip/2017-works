class AddSelfGameGloryPrizeToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :self_game_glory_prize, :integer, default: 0, comment: '自建赛场功勋奖励'
  end
end
