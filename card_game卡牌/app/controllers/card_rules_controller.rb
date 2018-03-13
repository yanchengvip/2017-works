class CardRulesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit]
  before_action :side_menus3
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @bout_number = 6
    @card_rules = CardRule.get_card_rules_by_bout 6
  end


  def show
    @card_rules = CardRule.get_card_rules_by_bout 1
  end

  def edit
    @sub_title = '卡牌使用规则修改'
    @bout_number = 6
    @card_rules = CardRule.get_card_rules_by_bout 6
    render '/card_rules/new'
  end


  def new
    @sub_title = '卡牌使用规则新增'
    @cards = Card.active.all
  end

  def create
     c = []
    ActiveRecord::Base.transaction do
      CardRule.active.update_all(delete_flag: true)
      card_rule_params.each do |crp|
        params[:energy_rules].each do |er|
            if crp[:bout_rank] == er[:bout_rank]
                c << crp.merge({init_energy: er[:init_energy],inject_energy_time: er[:inject_energy_time],
                           max_inject_energy: er[:max_inject_energy],inject_energy:er[:inject_energy]})
            end
        end
      end
      CardRule.create(c)
      BattleRule.update_battle_rule_flag
    end

    redirect_to '/card_rules'
  end


  private

  def card_rule_params
    params.permit(card_rules: [:card_id, :bout_rank, :card_consume_energy,:flag,:init_energy,
                               :inject_energy_time,:inject_energy,:max_inject_energy])[:card_rules]
  end
end
