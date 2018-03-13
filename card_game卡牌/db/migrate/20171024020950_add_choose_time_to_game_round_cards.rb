class AddChooseTimeToGameRoundCards < ActiveRecord::Migration[5.0]
  def change
    add_column :game_round_cards, :choose_time, :integer, default: 0, comment: '每轮计谋选取时间，单位：秒'
  end
end
