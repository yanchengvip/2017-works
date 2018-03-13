class AddRewardEnergyToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :reward_energy, :integer, default: 0, comment: '奖励能量数量'
  end
end
