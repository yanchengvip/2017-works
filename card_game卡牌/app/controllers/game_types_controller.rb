class GameTypesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,
                                               :game_products,:self_game_products,
                                               :game_product_shelf,:self_game_product_shelf]
  before_action :set_game_type
  before_action :side_menus1
  # before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :change_desc]

  def index
    @q = GameType.active.ransack(params[:q])
    @game_types = @q.result.includes(:game_rule).page(params[:page]).per(15)
  end

  def show
    @products = BattleProduct.select("id, sku, name").where(id: @game_type.product_ids&.split(',')) if @game_type.product_config_type == 2
    @game_rule = @game_type.game_rule
    # @card_bag_items = @game_type.card_bag.card_bag_items.includes(:card)
    @round_num = @game_rule.round_num
    @game_round_times = @game_rule.game_round_times
    @game_round_cards = @game_type.game_round_cards.to_a || []
  end

  def new
    @game_type = GameType.new
    # @product_tag_ids = BattleProduct.product_tag_ids
  end

  def create
    @game_type = GameType.new(game_type_params)
    begin
      ActiveRecord::Base.transaction do
        if @game_type.save!
          @game_type.update_attributes!(thumbnail: params[:thumbnail])
          @game_type.save_round_cards!(params[:round_cards])
        end
      end
      @game_type.push_to_java
      @game_type.clear_redis_data
      return flash_msg('success', '添加成功！', 'index')
    rescue Exception => e
      flash[:danger] = "添加失败！#{e.to_s}"
      return render action: :new
    end
  end

  def edit
    @products = BattleProduct.select("id, sku, name").where(id: @game_type.product_ids&.split(',')) if @game_type.product_config_type == 2
    # @card_bag_items = @game_type.card_bag.card_bag_items.includes(:card)
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@game_type.thumbnail&.to_s
    @thumbnail_path = @game_type.thumbnail

    @game_rule = @game_type.game_rule
    @round_num = @game_rule.round_num
    @game_round_times = @game_rule.game_round_times
    @game_round_cards = @game_type.game_round_cards.to_a || []
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        if @game_type.update_attributes!(game_type_params)
          @game_type.update_attributes!(thumbnail: params[:thumbnail])
          @game_type.save_round_cards!(params[:round_cards])
        end
      end
      @game_type.push_to_java
      @game_type.clear_redis_data
      return flash_msg('success', '修改成功！', 'index')
    rescue Exception => e
      flash['danger'] = "修改失败！#{e.to_s}"
      return redirect_to action: :edit, id: @game_type.id
    end
  end

  def destroy
    if @game_type.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  # 排序
  def get_order_num
    if game_type = EnergyProduct.active.where('order_num = ?', params[:num]).first
      return render json: {status: 500, msg: '排序不能重复！', data: {name: game_type.id}}
    end
    return render json: {status: 200, msg: 'success'}
  end

  def shelf
    begin
      if params[:shelf_status].to_i == 1
        @game_type.update_attributes!(status: 1)
      elsif params[:shelf_status].to_i == -1
        @game_type.update_attributes!(status: -1)
      end
      return render json: {status: 200, msg: '操作成功'}
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败"}
    end
  end

  def get_this_tag_products
    @products = BattleProduct.select("id, sku, name, inventory_count").where("game_product_tag_id = ? and is_game_product = 1", params['game_product_tag_id']&.to_i)

    return render partial: 'game_types/product/product_table'
  end

  def get_chosed_products
    @products = BattleProduct.select("id, sku, name").where(id: params['product_ids'].split(','))
    return render partial: 'game_types/product/chosed_products'
  end

  def get_chosed_game_rule
    @game_rule = GameRule.includes(:game_round_times).where("id =? ", params['game_rule_id']).first
    @game_round_times = @game_rule.game_round_times
    @round_num = @game_rule.round_num
    return render partial: 'game_types/game_rule/chosed_game_rule'
  end

  def get_chosed_card_bag
    @card_bag = CardBag.where("id = ?", params['card_bag_id']).first
    flag = @card_bag.check_card_ratio(params[:attack_ratio], params[:guard_ratio], params[:control_ratio])
    raise 'error' unless flag

    @card_bag_items = @card_bag.card_bag_items.includes(:card)
    return render partial: 'game_types/card_bag/chosed_card_bag'
  end

  def change_product_tag
    if @game_type.update_attributes!(game_product_tag_id: 0, product_ids: '')
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  # 修改规则说明
  def change_desc
    begin
      @game_type.update_attributes!(game_desc: params[:game_desc])
      flash_msg('success', '修改成功！', 'index')
    rescue Exception => e
      flash_msg('danger', '修改失败！', 'index')
    end
  end

  def get_game_type_name
    return render json: {status: 200, msg: 'success', data: @game_type.game_desc}
  end

  def game_products
    @product_tags = GameProductTag.active.where(status: 0)
    @q = BattleProduct.active.where(is_game_product: true).ransack(params[:q])
    @game_products = @q.result.page(params[:page]).per(15)
  end

  def self_game_products
    @product_tags = GameProductTag.active.where(status: 0)
    @q = BattleProduct.active.where(is_self_game_product: true).ransack(params[:q])
    @self_game_products = @q.result.page(params[:page]).per(15)
  end

  def show_product
    @battle_product = BattleProduct.active.where("id = ?", params[:product_id]).first
  end

  def mall_products
    @product_tags = GameProductTag.active.where(status: 0)
    @q = BattleProduct.active.ransack(params[:q])
    @game_products = @q.result.page(params[:page]).per(15)
  end

  def game_product_shelf
    @battle_product = BattleProduct.active.where("id = ?", params[:product_id]).first
    if @battle_product.update_attributes!(is_game_product: false)
      return render json: {status: 200, msg: 'succ'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def self_game_product_shelf
    @battle_product = BattleProduct.active.where("id = ?", params[:product_id]).first
    if @battle_product.update_attributes!(is_self_game_product: false)
      return render json: {status: 200, msg: 'succ'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def round_card_form
    @game_rule = GameRule.find params[:game_rule_id]
    @round_num = @game_rule.round_num
    @game_round_cards = []
    if params[:game_type_id].to_i > 0 && (@game_type = GameType.find params[:game_type_id])
      @game_round_cards = GameRoundCard.where(table_type: 'GameType', table_id: @game_type.id).active.to_a
    end

    return render partial: 'round_card_form'
  end


  private
  def game_type_params
    params.require(:game_type).permit(:glory_num, :energy_num, :product_ids, :order_num, :game_rule_id, :card_bag_id, :game_desc, :status, :product_config_type, :product_count, :name, :thumbnail, :game_product_tag_id, :begin_time_limit, :begin_time, :end_time, :product_worth, :reward_energy, :is_ai, :contest_type, :robot_wait_time, :robot_count)
  end

  def set_game_type
    @game_type = GameType.includes(:game_rule, :product_tag).where(id: params[:id]).first if params[:id]
  end

end
