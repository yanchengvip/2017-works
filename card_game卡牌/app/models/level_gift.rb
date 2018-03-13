class LevelGift < ApplicationRecord
  self.table_name = 'crm_level_gifts'
  belongs_to :glutton_level
  belongs_to :game_prop, foreign_key: 'gifts_id'

  def self.prop_for_chose
    GameProp.active.where(prop_type: '1').select('id, name').map{|p| [p.name, p.id]}
    # GameProp.active.where(prop_type: ['1', '2']).select('id, name').map{|p| [p.name, p.id]}
  end
end
