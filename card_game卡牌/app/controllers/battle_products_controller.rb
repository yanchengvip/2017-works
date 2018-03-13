class BattleProductsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,:update_status]
  before_action :side_menus7
  before_action :set_battle_product
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update, :order_manage_save, :update_status, :inventory_count_change, :order_update]

  def index
    @product_tags = ProductTag.active.where(status: 0)
    @battle_products = BattleProduct.show_index params
  end

  def show

  end

  def new
    @product_tags = ProductTag.active.where(status: 0)
    @game_product_tags = GameProductTag.active.where(status: true)
    @mall_product_tags = MallProductTag.active.where(status: true)
  end

  def create
    bp = BattleProduct.new(product_params.merge(mall_product_tag_ids: params[:mall_product_tag_ids]&.join(',')).merge(product_num: params[:product_num][params[:product_type]]))
    ActiveRecord::Base.transaction do
      if bp.save!
        Image.change_image_url bp, params[:image_urls]
        flash[:success] = '添加商品成功！'
        redirect_to '/battle_products'
      else
        flash[:danger] = '添加商品失败！'
        redirect_to '/battle_products'
      end
    end
  end


  def edit
    images = Image.get_image_url @battle_product
    @img_paths = images[:img_paths]
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@battle_product.thumbnail.to_s
    @thumbnail_path = @battle_product.thumbnail
    @page = params[:page].present? ? params[:page] : 1

    @product_tags = ProductTag.active.where(status: 0)
    @game_product_tags = GameProductTag.active.where(status: true)
    @mall_product_tags = MallProductTag.active.where(status: true)
  end

  def update
    se_hash = ge_hash = {}
    se_hash = {score_exchange: 0} if params[:score_exchange].blank?
    ge_hash = {glory_exchange: 0} if params[:glory_exchange].blank?
    page = params[:page].present? ? params[:page] : 1
    ActiveRecord::Base.transaction do
      @battle_product.update_attributes!(product_params.merge(se_hash).merge(ge_hash).merge(mall_product_tag_ids: params[:mall_product_tag_ids]&.join(',')).merge(product_num: params[:product_num][params[:product_type]]))
      Image.change_image_url @battle_product, params[:image_urls]
    end
    flash[:success] = '修改商品成功！'
    # redirect_to '/battle_products'
    return redirect_to action: :index, page: page
  end

  def destroy
    @battle_product.destroy
    flash[:danger] = '删除成功！'
    redirect_to '/battle_products'
  end


  #上架/下架状态
  def update_status
    @battle_product.update_attributes(status: params[:status])
    if params[:status].to_i == 0
      #下架
      @battle_product.update_attributes(down_shelf_time: Time.now)
    elsif params[:status].to_i == 1
      #上架
      @battle_product.update_attributes(on_shelf_time: Time.now)
    end
    redirect_to '/battle_products'
  end

  def inventory_count_manage
    @q = BattleProduct.active.ransack(params[:q])
    @battle_products = @q.result.includes(:product_tag).page(params[:page]).per(15)
  end

  # 增加、减少库存
  def inventory_count_change
    return flash_msg('danger', '操作失败！', 'inventory_count_manage') if params[:num].to_i <= 0
    num = params[:change_type] == '1' ? params[:num].to_i : (params[:num].to_i * -1)
    if @battle_product.update_attributes!(inventory_count: @battle_product.inventory_count + num)
      return flash_msg('success', '操作成功！', 'inventory_count_manage')
    end
    return flash_msg('danger', '操作失败！', 'inventory_count_manage')
  end

  def shelf_form
    return render partial: 'shelf_form'
  end

  def shelf
    if @battle_product.shelf!(params[:is_game_product], params[:is_self_game_product], params[:is_mall_product])
      return render json: {status: 200, msg: 'succ'}
    end
    return render json: {status: 500, msg: '操作失败'}
  end

  def orders
    @q = MallOrder.active.ransack(params[:q])
    @mall_orders = @q.result.includes(:battle_product, :battle_winning_record).page(params[:page]).per(15)
    # respond_to do |format|
    #   format.html
    #   format.csv {send_data(MallOrder.export_excel(@mall_orders), :type => "text/excel;charset=utf-8; header=present", :filename => '订单信息.csv' )}
    # end
    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(订单类型 赛场ID 幸运号码 兑换时间 商品名称 商品ID 商品价格 商品链接 支付方式 支付金额 用户昵称 用户手机号 收货姓名 收货电话 收货地址)
        @q.result.each do |r|
          csv << [MallOrder::ORDER_TYPE[r.order_type], r.battle_id, r.lucky_code, r.created_at&.strftime("%Y-%m-%d %H:%m:%S"), r.product_name, r.battle_product_id, r.market_price, r.battle_product&.detail_url, MallOrder::PAYTYPE[r.pay_type], r.pay_num, r.user&.nick_name, r.user&.mobile, r.consignee, r.mobile, r.shipping_address]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def order_edit
    @mall_order = MallOrder.where("id = ?", params[:order_id]).first
  end

  def order_update
    @mall_order = MallOrder.where("id = ?", params[:order_id]).first
    @mall_order.update_attributes!(params.slice('status', 'logistics_company', 'logistics_num').permit!)
    flash[:success] = '修改成功！'
    redirect_to "/battle_products/order_edit?order_id=#{@mall_order.id}"
  end


  private

  def set_battle_product
    @product_tags = ProductTag.where(status: 0, delete_flag: false)
    @battle_product = BattleProduct.includes(:product_tag, :images).find(params[:id]) if params[:id]
  end

  def product_params
    params.permit(:name, :market_price, :inventory_count, :postage, :thumbnail,
                 :product_tag_id, :sku, :status, :sort, :is_game_product, :game_product_tag_id, :is_self_game_product, :is_mall_product, :mall_product_tag_ids, :score_exchange, :score, :glory_exchange, :glory, :desc, :detail_url, :product_type, :product_num)
  end


end
