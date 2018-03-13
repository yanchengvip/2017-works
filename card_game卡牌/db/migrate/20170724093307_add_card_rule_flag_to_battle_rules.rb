class AddCardRuleFlagToBattleRules < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_rules, :card_rule_flag, :string, comment: '卡牌规则唯一标识'
  end
end
