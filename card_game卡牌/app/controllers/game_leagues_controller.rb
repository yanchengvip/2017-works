class GameLeaguesController < ApplicationController
  # protect_from_forgery :except => :relive
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:relive, :save_league_rule]
  before_action :side_menus1
  before_action :set_game_league, except: [:relive_rule, :relive]

  def index
    @q = GameLeague.active.ransack(params[:q])
    @game_leagues = @q.result.includes(:game_league_battles).page(params[:page]).per(15)
  end

  def show
    @game_league_battles = @game_league.game_league_battles
    @robot_language = @game_league.robot_language&.split('#')
  end

  def new
    @game_league = GameLeague.new
    @game_types = GameType.active.where(contest_type: 2)
    @robot_language = []
  end

  def create
    @game_league = GameLeague.new(game_league_params.merge(robot_language: params[:robot_text].join('#')))
    begin
      ActiveRecord::Base.transaction do
        if @game_league.save!
          @game_league.save_items!(params[:game_img], params[:robot_difficulty], params[:robot_prize])
        end
        flash[:success] = '添加成功！'
      end
      @game_league.push_to_java
      return redirect_to action: :index
    rescue Exception => e
      @game_types = GameType.active.where(contest_type: 2)
      @robot_language = []
      flash[:danger] = '添加失败！' + e.to_s
      return render action: :new
    end
  end

  def edit
    return redirect_to action: :index unless (@game_league.league_begin.blank? || Time.now < @game_league.league_begin)
    @game_league_battles = @game_league.game_league_battles
    @game_types = GameType.active.where(contest_type: 2)
    @product = BattleProduct.find @game_league.battle_product_id
    @robot_language = @game_league.robot_language&.split('#')
  end

  def update
    return redirect_to action: :index unless (@game_league.league_begin.blank? || Time.now < @game_league.league_begin)
    begin
      ActiveRecord::Base.transaction do
        if @game_league.update_attributes!(game_league_params.merge(robot_language: params[:robot_text].join('#')))
          @game_league.save_items!(params[:game_img], params[:robot_difficulty], params[:robot_prize])
        end
        flash[:success] = '修改成功！'
      end
      @game_league.push_to_java
      return redirect_to action: :index
    rescue Exception => e
      flash[:danger] = '修改失败！' + e.to_s
      return redirect_to action: :edit, id: @game_league.id
    end
  end

  def shelf
    begin
      if params[:shelf_status].to_i == 0 && @game_league.update_column(:league_end, Time.now)
        @game_league.push_to_java
        @game_league.java_stop
        return render json: {status: 200, msg: '操作成功'}
      end
      return render json: {status: 500, msg: "操作失败"}
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败1" + e.to_s}
    end
  end

  def get_item_form
    return render partial: 'item_form'
  end

  def destroy_item
    begin
      ActiveRecord::Base.transaction do
        rule_item = GameLeagueItem.find_by(id: params[:rule_item_id].to_i)
        if rule_item && rule_item.destroy!
          @game_league.update_total! rule_item.amount * rule_item.count
        end
        return render json: {status: 200, msg: 'success'}
      end
    rescue Exception => e
      return render json: {status: 500, msg: 'error'+e.to_s}
    end
  end

  def get_prize
    @products = BattleProduct.active.where(game_product_tag_id: params[:game_product_tag_id])
    return render partial: 'prize_form'
  end

  def relive_rule
    @web_setting = WebSetting.select('id, relive_rule, write_invite_code_reward_times, been_write_invite_code_reward_times').first || WebSetting.new
  end

  def relive
    @web_setting = WebSetting.select('id, relive_rule, write_invite_code_reward_times, been_write_invite_code_reward_times').first || WebSetting.new
    @web_setting.save_relive_rule params[:relive_rule], params[:write_invite_code_reward_times], params[:been_write_invite_code_reward_times]
    return redirect_to action: :relive_rule
  end

  def copy
    res = @game_league.copy!
    if res[:status] == true
      return render json: {status: 200, msg: '复制成功'}
    end
    return render json: {status: 500, msg: res[:msg]}
  end

  def league_rule
    @league_rule_setting = Setting.where(var: 'league_rule').first || Setting.new(var: 'league_rule')
  end

  def save_league_rule
    @league_rule_setting = Setting.where(var: 'league_rule').first
    if @league_rule_setting.blank?
      @league_rule_setting = Setting.create(var: 'league_rule', value: params[:league_rule])
    else
      @league_rule_setting.update_attributes(value: params[:league_rule])
    end
    @league_rule_setting.push_to_java
    return redirect_to action: :league_rule
  end


  private

  def game_league_params
    params.require(:game_league).permit!
  end

  def set_game_league
    @game_league = GameLeague.find(params[:id]) if params[:id]
  end

end
