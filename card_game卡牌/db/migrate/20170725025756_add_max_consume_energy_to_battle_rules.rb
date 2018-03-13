class AddMaxConsumeEnergyToBattleRules < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_rules, :max_consume_energy, :integer, default: 0, comment: '战役消耗最大能量'
  end
end
