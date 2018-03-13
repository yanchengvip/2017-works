class RenameWarnRulesTableToBattleRuleWarns < ActiveRecord::Migration[5.0]
  def change
    rename_table :warn_rules,:battle_rule_warns
  end
end
