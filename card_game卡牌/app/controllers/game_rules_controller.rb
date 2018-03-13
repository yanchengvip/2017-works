class GameRulesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_filter :set_game_rule
  before_filter :side_menus1
  # before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = GameRule.active.ransack(params[:q])
    @game_rules = @q.result.page(params[:page]).per(15)
  end

  def show
    @game_round_times = @game_rule.game_round_times.select('id, round_num, round_time').to_a
  end

  def new
    @game_rule = GameRule.new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        game_rule = GameRule.new(game_rule_params)
        if game_rule.save!
          game_rule.save_round_times!(params[:round_times])
          return flash_msg('success', '添加成功！', 'index')
        end
        return flash_msg('danger', "添加失败！#{error_msg(game_rule)}", 'new')
      end
    rescue Exception => e
      return flash_msg('danger', "添加失败！", 'new')
    end
  end

  def edit
    @game_round_times = @game_rule.game_round_times.select('id, round_num, round_time').to_a
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        if @game_rule.update_attributes!(game_rule_params)
          @game_rule.save_round_times!(params[:round_times])
          return flash_msg('success', '修改成功！', 'index')
        else
          flash[:danger] = '修改失败！#{error_msg(@game_rule)}'
          return redirect_to action: :edit, id: @game_rule.id
        end
      end
    rescue Exception => e
      flash[:danger] = '修改失败！#{error_msg(@game_rule)}'
      return redirect_to action: :edit, id: @game_rule.id
    end
  end

  def destroy
    if @game_rule.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  # 排序
  def get_order_num
    if energy_product = EnergyProduct.active.where('order_num = ?', params[:num]).first
      return render json: {status: 500, msg: '排序不能重复！', data: {name: energy_product.name}}
    end
    return render json: {status: 200, msg: 'success'}
  end

  def round_time_form
    @round_num = params[:r_num].to_i
    @game_round_times = []
    if params[:game_rule_id].to_i > 0
      @game_round_times = GameRoundTime.select('id, round_num, round_time').where(table_type: 'GameRule', table_id: params[:game_rule_id].to_i).active.to_a
    end

    return render partial: 'round_time_form'
  end

  def round_card_form
    @round_num = params[:r_num].to_i
    @game_round_cards = []
    if params[:game_rule_id].to_i > 0
      @game_round_cards = GameRoundCard.where(table_type: 'GameRule', table_id: params[:game_rule_id].to_i).active.to_a
    end

    return render partial: 'round_time_form'
  end



  private
  def game_rule_params
    params.require(:game_rule).permit(:name, :round_num, :round_time, :open_user_num, :max_user_num, :over_time,
                  :play_init_cd, :play_min_cd, :play_max_cd, :deal_init_cd, :deal_min_cd, :deal_max_cd, :init_card_num,
                  :card_max_num, :play_cd_inc, :round_baofu_num, :loser_baofu_min_num, :loser_baofu_max_num, :winner_bxf, :loser_bxf)
  end

  def set_game_rule
    @game_rule = GameRule.where(id: params[:id]).first if params[:id]
  end

end
