class AddMaxConsumeEnergyToBattleRulesCopies < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_rules_copies, :card_rule_flag, :string, comment: '卡牌规则唯一标识'
    add_column :battle_rules_copies, :max_consume_energy, :integer, comment: 'max_consume_energy'

  end
end
