class BattlesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :side_menus1
  before_action :side_menus6, only: [:csv_index]
  before_action :set_battle, only: [:show, :destroy, :edit, :update, :update_status]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update, :update_status]

  def index
    @battles = Battle.show_index params
  end

  def csv_index
    index
  end


  def show
    @bpc = @battle.battle_products_copies.includes(:images, :product_tag).active.first
    @brc = @battle.battle_rules_copies.includes(:battle_rule).active.first
    @battle_packages = BattlePackage.includes(:package).where(battle_id: @battle.id).active
    @battle_rule = @brc.battle_rule
    if @battle_rule.present?
      @is_use_battle_rule_show = 1 #复用战役规则页面
      @br_warns = @battle_rule.battle_rule_warns.active.order(bout_rank: :asc)
      @bout_number = @battle_rule.bout_number.to_i
      @card_rules = CardRule.get_card_rules_by_bout @bout_number,@battle_rule.card_rule_flag,'delete_flag'
    end

  end

  def new
    @battle_rules = BattleRule.select(:id, :name).active.where(status: 0)

  end

  def create
    pa = Battle.handle_battle_params params
    bp = BattleProduct.where(id: params[:bp_id_val]).active.first

    if [1, 3].include?(params[:award_setting1].to_i) && !bp.present?
      flash[:success] = '添加战役失败！可领实物的商品不能为空'
      redirect_to "/battles/new" and return
    end

    ActiveRecord::Base.transaction do
      battle = Battle.new(battle_params.merge(pa))
      if battle.save
        Image.change_image_url battle, params[:image_urls]
        battle.create_bp_copy params[:bp_id_val]
        battle.create_br_copy params[:battle_rule_id]
        battle.create_battle_package params[:battle_packages]
        flash[:success] = '添加战役成功！'
      else
        flash[:error] = '添加战役失败！'
      end
    end
    redirect_to '/battles'
  end

  def edit
    update_battle_permission
    brc = @battle.battle_rules_copies.first
    @battle_product = @battle.battle_products_copies.first
    @battle_products_copy_id = @battle_product.id
    @br_id = brc.present? ? brc.battle_rule_id : ''

    images = Image.get_image_url @battle
    @img_paths = images[:img_paths]
    @packages = Package.joins('left join package_types as pt on pt.id = packages.package_type_id')
                    .where('pt.sale_channel = ? and pt.delete_flag = ? and packages.prize_type in (?) and packages.status = ?', 3, false, [1,3],1).active
    @battle_packages = BattlePackage.includes(:package).where(battle_id: @battle.id).active
  end

  def update
    update_battle_permission
    pa = Battle.handle_battle_params params
    bp = BattleProduct.where(id: params[:bp_id_val]).active.first
    bp_copy_id = params[:bp_copy_id] #用户判断是否修改了战役关联的商品，如果存在则没有修改快照商品
    if !bp_copy_id.present? && !bp.present?
      flash[:success] = '修改战役失败！可领实物的商品不能为空'
      redirect_to "/battles/#{params[:id]}/edit" and return
    end

    ActiveRecord::Base.transaction do
      @battle.update_attributes(battle_params.merge(pa))
      Image.change_image_url @battle, params[:image_urls]
      bpc = @battle.battle_products_copies.first
      brc = @battle.battle_rules_copies.first
      br_id = brc.present? ? brc.battle_rule_id : ''
      if !bp_copy_id.present?
        @battle.create_bp_copy params[:bp_id_val]
        if bpc.present? && bp.present?
          bpc.destroy!()
        end
      end

      if br_id != params[:battle_rule_id].to_i
        @battle.create_br_copy params[:battle_rule_id]
        if brc.present?
          brc.destroy!()
        end

      end

      @battle.update_battle_package params[:battle_packages]

      flash[:success] = '修改战役成功！'
    end
    redirect_to ("/battles/#{@battle.id}/edit") and return
  end

  def destroy
    update_battle_permission
    @battle.destroy()
    flash[:success] = '删除战役成功！'
    redirect_to '/battles'
  end

  def search_bp
    @battle_product = BattleProduct.where(id: params[:bp_id], delete_flag: 0).first
    if @battle_product.nil?
      @message = {status: 'error', message: '商品不存在或已删除'}
    else

      if @battle_product.status == 0
        @message = {status: 'error', message: '商品已下架'}
      end
      if @battle_product.inventory_count < 1
        @message = {status: 'error', message: '商品库存不足'}
      end
    end
    render partial: 'battles/search_bp'
  end


  #上架、下架
  def update_status
    flash[:success] = '不能修改上架/下架状态！'
    if [0, 2].include?(@battle.status)
      if params[:status].present? && params[:status].to_i == 0
        @battle.update_attributes(status: 0, on_shelf_time: Time.now)
      elsif params[:status].to_i == 2
        @battle.update_attributes(status: 2, down_shelf_time: Time.now)
      end
      flash[:success] = '修改上架/下架状态成功！'
    end
    redirect_to '/battles'
  end

  def battle_package_tr
    @packages = Package.where(id: params[:package_ids]).active
    render partial: 'battles/battle_package_tr'
  end

  #新建battle modal中显示package列表
  def battle_package_table
    @packages = Package.joins(:package_type)
                    .where('package_types.sale_channel = ? and package_types.delete_flag = ?', 3, false).active
                    .page(params[:page]).per(10)
    render partial: 'battles/packages/package_win_table'
  end

  def battle_package_tr_fail
    @packages = Package.where(id: params[:package_ids]).active
    render partial: 'battles/battle_package_tr_fail'
  end


  private

  def set_battle
    @battle_rules = BattleRule.select(:id, :name).active.where(status: 0)
    @battle = Battle.includes(:battle_products_copies, :battle_rules_copies,:battle_winning_record).find(params[:id])
  end

  def battle_params
    params.permit(:name, :status, :battle_rank, :entrance_ticket_number, :published_at, :begin_time, :end_time,
                  :award_setting, :exchange_micro_ticket, :desc,)
  end


  def update_battle_permission
    if [3, 4, 5, 6].include?(@battle.status)
      flash[:danger] = '战役开始后不能修改'
      redirect_to '/battles'
    end
  end
end
