class BattleRuleCard < ApplicationRecord
  belongs_to :card
  belongs_to :battle_rule

end