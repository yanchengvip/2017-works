class AddEnergyToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :energy, :integer, default: 0, comment: '卡牌消耗能量'
    add_column :cards, :attack_energy, :integer, default: 0, comment: '消耗对方的能量'
    add_column :cards, :use_times, :integer, default: 0, comment: '使用次数，0：无限次'
  end
end
