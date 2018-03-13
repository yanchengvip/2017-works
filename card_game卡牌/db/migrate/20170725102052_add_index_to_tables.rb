class AddIndexToTables < ActiveRecord::Migration[5.0]
  def change
    add_index :battle_rules_copies, :card_rule_flag
    add_index :battle_rules, :card_rule_flag
    add_index :card_rules, :flag
  end
end
