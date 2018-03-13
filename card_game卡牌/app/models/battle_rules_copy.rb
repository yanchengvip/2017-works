class BattleRulesCopy < ApplicationRecord
  belongs_to :battle_rule
  belongs_to :battle
  validates :name,:bout_number,:open_person_number,:bout_time, presence: true
end