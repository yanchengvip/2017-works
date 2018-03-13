class BattleRulePackage < ApplicationRecord
  belongs_to :battle_rule
  belongs_to :package
  validates :battle_rule_id,:package_id, presence: true
  validates_uniqueness_of :battle_rule_id,scope: [:package_id,:delete_flag]
end