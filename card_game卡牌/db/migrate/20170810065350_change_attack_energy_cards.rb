class ChangeAttackEnergyCards < ActiveRecord::Migration[5.0]
  def change
    change_column :cards, :attack_energy, :decimal, default: 0, precision: 3, scale: 2, comment: '转移对方能量的百分比'
  end
end
