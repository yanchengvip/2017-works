module CardDataHelper
  extend ActiveSupport::Concern
  module ClassMethods
    def card_info_csv_data params
      data_arr = []
      index = SYSTEMCONFIG[:es_table_prefix] + "battles"
      start_time = DateTime.parse(params[:published_at_begin]&.to_s).strftime('%Y-%m-%dT00:00:01.000Z').to_s if params[:published_at_begin].present?
      end_time = DateTime.parse(params[:published_at_end]&.to_s).strftime('%Y-%m-%dT23:59:59.000Z').to_s if params[:published_at_end].present?
      if params[:created_at_begin].present? && params[:created_at_end].present?
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :range => { :published_at => { :gte => start_time, :lte => end_time }}
                },
                :size=>10000
            }
          })
      else
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :match_all => {}
                },
                :size=>10000
            }
          })
      end
        results = response["hits"]["hits"]
        results.each do |result|
          battle = Battle.find(result["_source"]["id"].to_i)
          card_use_num = CardUserRecord.where(battle_id: battle.id).sum(:use_num)
          card_user_count = CardUserRecord.distinct(:user_id).where(battle_id: battle.id).count(:user_id)
          brc = battle.battle_rules_copies.includes(:battle_rule).active.first
          battle_rule = brc.battle_rule
          battle_rule_cards = BattleRuleCard.select(:bout_rank).where(battle_rule_id: battle_rule.id).active.group(:bout_rank).sum(:card_consume_number)
          battle_cards = BattleRuleCard.select(:bout_rank,:card_consume_number,'cards.name').joins(:card).where(battle_rule_id: battle_rule.id).active.group('battle_rule_cards.bout_rank,card_consume_number,cards.name')
          on_shelf_time = DateTime.parse(result["_source"]["on_shelf_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s if result["_source"]["on_shelf_time"].present?
          begin_time = DateTime.parse(result["_source"]["begin_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s if result["_source"]["begin_time"].present?
          battle_cards.each do |card|
            data_arr << [
              on_shelf_time,
              begin_time,
              battle.id,
              battle.name,
              battle_rule.id,
              battle_rule.bout_number,
              battle.battle_products_copies.active.first&.sku,
              battle.battle_products_copies.active.first&.name,
              battle_rule.open_person_number,
              battle_rule.max_person_number,
              card_use_num,
              card_user_count,
              battle_rule_cards.keys,
              battle_rule_cards.values,
              card.name,
              card.bout_rank,
              card.card_consume_number
            ]
          end
        end
        return data_arr
    end
  end
end
