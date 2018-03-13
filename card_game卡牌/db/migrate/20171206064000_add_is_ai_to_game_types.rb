class AddIsAiToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :is_ai, :boolean, default: false, comment: '是否机器人赛场，默认0:不是，1:是'
  end
end
