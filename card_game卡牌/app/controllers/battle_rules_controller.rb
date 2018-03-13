class BattleRulesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus1
  before_action :set_battle_rule, only: [:show, :destroy, :edit, :update, :update_status]
  before_action :battle_rules_params, only: [:create, :update]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update, :update_status]

  def index
    @battle_rules = BattleRule.includes(:battle_rules_copies).show_index params
  end

  def show
    @br_warns = @battle_rule.battle_rule_warns.active.order(bout_rank: :asc)
    @bout_number = @battle_rule.bout_number
    @card_rules = CardRule.get_card_rules_by_bout @bout_number,@battle_rule.card_rule_flag,'delete_flag'
  end

  def new
    @bout_number = 1
    @card_rules = CardRule.get_card_rules_by_bout 1
    if @card_rules[1].empty?
      flash[:danger] = '卡牌规则为空，请前往【系统管理】，添加卡牌规则'
      redirect_to "/battle_rules" and return
    end
  end

  def create
    ActiveRecord::Base.transaction do
      br = BattleRule.new(battle_rules_params.merge(taoti_blood: params[:taoti_blood].join(','),card_rule_flag: CardRule.active.first.flag))
      if br.save
        battle_rule_warns_params.each do |brw|
          if params[:bout_rank_checked_array].present? && params[:bout_rank_checked_array].include?(brw[:bout_rank])
            br.battle_rule_warns.create!(bout_rank: brw[:bout_rank], limit_time_begin: brw[:limit_time_begin],
                                        micro_score: brw[:micro_score], phone: params[:warn_phone])
          end
        end
        flash[:success] = '添加战役规则成功！'
      else
        flash[:success] = '添加战役规则失败！'
      end
    end
    redirect_to '/battle_rules'
  end

  def edit
    update_battle_rule_permission
    @bout_number = @battle_rule.bout_number
    @taoti_blood = @battle_rule.taoti_blood.split(',')
    @card_rules = CardRule.get_card_rules_by_bout @bout_number,'delete_flag'
    @battle_rule_warns = @battle_rule.get_edit_warn_rules
  end

  def update
    update_battle_rule_permission
    ActiveRecord::Base.transaction do
      @battle_rule.update_attributes(battle_rules_params.merge(taoti_blood: params[:taoti_blood].join(',')))
      @battle_rule.update_br_card_and_warn(battle_rule_warns_params, params[:bout_rank_checked_array], params[:warn_phone])
    end

    flash[:success] = '修改战役规则成功！'
    redirect_to "/battle_rules/#{@battle_rule.id}/edit"
  end

  def destroy
    @battle_rule.destroy
    flash[:success] = '删除战役规则成功！'
    redirect_to '/battle_rules'
  end

  #禁用、启用状态
  def update_status
    @battle_rule.update_attributes!(status: params[:status])
    flash[:success] = '修改成功！'
    redirect_to '/battle_rules'
  end

  #卡牌使用规则
  def set_card_rule
    @bout_number = params[:bout_number].to_i
    @card_rules = CardRule.get_card_rules_by_bout @bout_number
    render partial: 'battle_rules/set_card_rule'
  end



  # def get_rule_packages
  #   pt = PackageType.where(name: params[:pt_name], sale_channel: 2).active.first
  #   pt_id = pt.present? ? pt.id : 0
  #   @packages = Package.includes(:package_type).where(package_type_id: pt_id, status: 1, prize_type: 1)
  #                   .page(params[:page]).per(10)
  #   render partial: 'battle_rules/packages/package_table'
  # end
  #
  #
  # def selected_rule_package
  #   package = Package.includes(:package_type).find(params[:package_id])
  #   data = {id: package.id, name: package.name, price: package.price.to_f,pt_name: package.package_type.name}
  #   render json: data
  # end

  private


  def set_battle_rule
    @battle_rule = BattleRule.find(params[:id])
  end

  def battle_rules_params
    params.permit(:name, :status, :bout_number, :open_person_number, :max_person_number, :bout_time,:max_consume_energy,
                  :desc,:taoti_blood)
  end


  def battle_rule_warns_params
    params.permit(battle_rule_warns: [:is_checked, :bout_rank, :limit_time_begin, :micro_score])[:battle_rule_warns]
  end


  # def battle_rule_package_params
  #   params.permit(packages: [:name, :price, :package_id, :battle_rule_id,:pt_name])[:packages]
  # end

  def update_battle_rule_permission
    #如果规则已被使用，则禁止修改
    brc = @battle_rule.battle_rules_copies.active
    if brc.present?
      flash[:danger] = '战役规则已被使用，不能修改！'
      redirect_to "/battle_rules" and return
    end
  end
end
