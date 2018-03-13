class SelfGameRulesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,:shelf]
  before_filter :set_self_game_rule
  before_filter :side_menus1
  before_action :init_params_search, only: [:index]
  # skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = SelfGameRule.active.ransack(params[:q])
    @self_game_rules = @q.result.page(params[:page]).per(15)
  end

  def show
    # @card_bag_items = @self_game_rule.card_bag.card_bag_items.includes(:card)
    @game_round_cards = GameRoundCard.where(table_type: 'SelfGameRule', table_id: @self_game_rule.id).active.to_a || []
    @round_num = @game_round_cards.size
    @game_round_times = @self_game_rule.game_round_times
  end

  def new
    @self_game_rule = SelfGameRule.new
  end

  def create
    @self_game_rule = SelfGameRule.new(self_game_rule_params)
    begin
      ActiveRecord::Base.transaction do
        if @self_game_rule.save!
          @self_game_rule.save_round_times!(params[:round_times])
          @self_game_rule.save_round_cards!(params[:round_cards])
        end
      end
      @self_game_rule.clear_redis_data
      return flash_msg('success', '添加成功！', 'index')
    rescue Exception => e
      flash[:danger] = "添加失败！#{e.to_s}"
      return render action: :new
    end
  end

  def edit
    @game_round_cards = GameRoundCard.where(table_type: 'SelfGameRule', table_id: @self_game_rule.id).active.to_a || []
    @round_num = @game_round_cards.size
    @game_round_times = @self_game_rule.game_round_times
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        if @self_game_rule.update_attributes!(self_game_rule_params)
          @self_game_rule.save_round_times!(params[:round_times])
          @self_game_rule.save_round_cards!(params[:round_cards])
        end
      end
      @self_game_rule.clear_redis_data
      return flash_msg('success', '修改成功！', 'index')
    rescue Exception => e
      flash[:danger] = '修改失败！#{error_msg(@self_game_rule)}'
      return redirect_to action: :edit, id: @self_game_rule.id
    end
  end

  def destroy
    if @self_game_rule.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  # 启用
  def shelf
    begin
      if params[:shelf_status].to_i == 1
        @self_game_rule.update_attributes!(status: 1)
      elsif params[:shelf_status].to_i == 0
        @self_game_rule.update_attributes!(status: 0)
      end
      return render json: {status: 200, msg: '操作成功'}
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败"}
    end
  end

  def round_time_form
    @round_num = params[:r_num].to_i
    @game_round_times = []
    if params[:game_rule_id].to_i > 0
      @game_round_times = GameRoundTime.select('id, round_num, round_time').where(table_type: 'SelfGameRule', table_id: params[:game_rule_id].to_i).active.to_a
    end

    return render partial: 'round_time_form'
  end

  def round_card_form
    @round_num = params[:r_num].to_i
    @game_round_cards = []
    if params[:game_rule_id].to_i > 0
      @game_round_cards = GameRoundCard.where(table_type: 'SelfGameRule', table_id: params[:game_rule_id].to_i).active.to_a
    end

    return render partial: 'round_card_form'
  end


  private
  def self_game_rule_params
    params.require(:self_game_rule).permit(:name, :round_num, :round_time,:play_init_cd, :play_min_cd, :play_max_cd,
                   :deal_init_cd, :deal_min_cd, :deal_max_cd, :init_card_num, :card_max_num, :play_cd_inc,
                   :round_baofu_num, :loser_baofu_min_num, :loser_baofu_max_num, :card_bag_id, :game_desc, :winner_bxf, :loser_bxf)
  end

  def set_self_game_rule
    @self_game_rule = SelfGameRule.find(params[:id]) if params[:id]
  end

end
