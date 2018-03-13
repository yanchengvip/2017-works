class CardRule < ApplicationRecord
  belongs_to :card
  validates :flag, presence: :true


  #按每轮分类
  def self.get_card_rules_by_bout rank_bout,*args
    conditions = ['bout_rank <= ?']
    values = [rank_bout]
    if args[0].present?
      conditions << 'flag = ?'
      values << args[0]
    end
    if !args[1].present?
      conditions << 'delete_flag = ?'
      values << false
    end

    cards_hash = {}
    card_rule = CardRule.where(conditions.join(' and '),*values).includes(:card).order('bout_rank asc')
    rank_bout.times do |n|
      bout = n+1
      cards_arr = []
      card_rule.each do |cr|
        if cr.bout_rank == bout
          c = {id: cr.id,flag: cr.flag, bout_rank: bout,
               card_consume_energy: cr.card_consume_energy,name: cr.card.name,card_id: cr.card.id,
               init_energy: cr.init_energy,inject_energy_time: cr.inject_energy_time,inject_energy: cr.inject_energy,
               max_inject_energy: cr.max_inject_energy,
               card_type: cr.card.card_type, price: cr.card.price.to_f, summary: cr.card.summary}

          cards_arr.push(c)
        end

      end
      cards_hash[bout] = cards_arr
    end

    return cards_hash
  end



end