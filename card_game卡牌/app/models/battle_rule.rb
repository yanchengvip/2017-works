class BattleRule < ApplicationRecord
  has_many :battle_rule_cards
  has_many :battle_rule_warns
  has_many :battle_rules_copies
  has_many :battle_rule_packages,-> { where(delete_flag: false) }, :dependent => :destroy
  validates :name, presence: true
  validates :card_rule_flag, presence: true

  #修改战役时，按卡牌被选中使用情况和每轮分类
  def get_edit_cards
    battle_rule = BattleRule.includes(:battle_rule_cards).find(self.id)
    bout_number = battle_rule.bout_number
    cards = Card.active.all
    cards_hash = {}
    battle_rule_cards = battle_rule.battle_rule_cards.includes(:card).active
    bout_number.times do |n|
      bout = n+1
      cards_arr = []
      cards.each do |card|
        c = {id: card.id, battle_rule_card_id: 0, name: card.name, is_checked: '', card_type: card.card_type, price: card.price,
             bout_rank: bout, card_consume_number: 1, card_limit_number: 1, summary: card.summary}

        battle_rule_cards.each do |brc|
          if brc.card_id == card.id && brc.bout_rank == bout
            c[:is_checked] = 'checked'
            c[:battle_rule_card_id] = brc.id
            c[:card_consume_number] = brc.card_consume_number
            c[:card_limit_number] = brc.card_limit_number
          end
        end
        cards_arr.push(c)
      end
      cards_hash[bout] = cards_arr
    end

    return cards_hash
  end


  #修改战役时，报警规则显示
  def get_edit_warn_rules
    battle_rule = BattleRule.includes(:battle_rule_warns).find(self.id)
    bout_number = battle_rule.bout_number
    warn_arr = []
    bout_number.times do |n|
      bout = n+1
      warn_hash = {bout_rank: bout, limit_time_begin: 5, micro_score: 10, phone: '', is_checked: '', warn_id: 0, }
      battle_rule.battle_rule_warns.active.each do |brw|
        if brw.bout_rank == bout
          warn_hash[:is_checked] = 'checked'
          warn_hash[:limit_time_begin] = brw.limit_time_begin
          warn_hash[:micro_score] = brw.micro_score
          warn_hash[:phone] = brw.phone
          warn_hash[:warn_id] = brw.id
        end
      end
      warn_arr.push(warn_hash)
    end
    return warn_arr
  end


  def update_br_card_and_warn battle_rule_warns_params, bout_ranks, phone


    old_bout_ranks = self.battle_rule_warns.active.pluck(:bout_rank)
    new_bout_rank = bout_ranks
    del_bout_ranks = old_bout_ranks - new_bout_rank

    del_bout_ranks.each do |dr|
      self.battle_rule_warns.active.where(bout_rank: dr).first.destroy()
    end
    battle_rule_warns_params.each do |brwp|
      if new_bout_rank.include?(brwp[:bout_rank])
        brw = self.battle_rule_warns.active.where(bout_rank: brwp[:bout_rank]).first
        if brw
          brw.update_attributes!(limit_time_begin: brwp[:limit_time_begin], micro_score: brwp[:micro_score], phone: phone)
        else
          self.battle_rule_warns.create!(bout_rank: brwp[:bout_rank], limit_time_begin: brwp[:limit_time_begin],
                                         micro_score: brwp[:micro_score], phone: phone)
        end
      end

    end
  end


  #战役规则列表展示
  def self.show_index params
    conditions = []
    values = []
    if params[:name].present?
      conditions << 'name like ?'
      values << "%#{params[:name]}%"
    end

    if params[:bout_number].present? && params[:bout_number].to_i != -1
      conditions << 'bout_number = ?'
      values << params[:bout_number]
    end

    if params[:status].present? && params[:status].to_i != -1
      conditions << 'status = ?'
      values << params[:status]
    end

    @battle_rules = BattleRule.where(conditions.join(' and '), *values).active
                        .order('status asc', 'created_at desc').page(params[:page]).per(20)
  end



  #修改战役规则对应的礼包
  def update_br_packages params
    new_brp_ids = params.map{|par| par[:brp_id].to_i}
    old_brp_ids = self.battle_rule_packages.active.pluck(:id)
    del_brp_ids = old_brp_ids - new_brp_ids
    del_brp_ids.each do |id|
       BattleRulePackage.find(id).destroy()
    end
    params.delete_if{|i|  i[:brp_id].present?}
    self.battle_rule_packages.create!(params.as_json)
  end

  #卡牌规则改变后，修改关联的卡牌规则
  def self.update_battle_rule_flag
    #已被开始的战役占用的战役规则
    br_ids = BattleRule.joins('left join battle_rules_copies as brc on brc.battle_rule_id = battle_rules.id
                    left join battles on battles.id = brc.battle_id')
                 .where('battles.status in (?)',[3,4,5,6]).distinct.pluck(:id)
    all_ids = BattleRule.active.pluck(:id)
    c = CardRule.active.first
    BattleRule.where(id: all_ids - br_ids).update_all(card_rule_flag: c.flag)
    BattleRulesCopy.joins('left join battles on battles.id = battle_rules_copies.battle_id')
        .where('battles.status in (?)',[0,2]).active.update_all(card_rule_flag: c.flag)
  end
end