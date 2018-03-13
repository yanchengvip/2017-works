class MallProductsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,:shelf]
  before_action :side_menus4
  before_action :set_mall_product
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update,
                                                        :order_manage_save, :update_status, :sort]

  def index
    @q = BattleProduct.active.where(is_mall_product: true).ransack(params[:q])
    @mall_products = @q.result.page(params[:page]).per(15)
  end

  def show

  end

  def onshelf
    conditions = ['status = ?']
    values = ['1']
    if params[:name].present?
      conditions << 'name like ? '
      values << "%#{params[:name]}%"
    end
    @mall_products = MallProduct.where(conditions.join(' and '),*values).active
                         .order('sort desc').page(params[:page].to_i).per(20)
  end


  #上架/下架状态
  def update_status
    @mall_product.update_attributes(status: params[:status])
    if params[:status].to_i == 0
      #下架
      @mall_product.update_attributes(down_shelf_time: Time.now)
    elsif params[:status].to_i == 1
      #上架
      @mall_product.update_attributes(on_shelf_time: Time.now)
    end
    redirect_to :back
  end

  #排序
  def sort
    @mall_product.update_attributes(sort: params[:sort])
    redirect_to :back
  end

  def new
    @product_tags = ProductTag.active.where(status: 0)
  end

  def create
    mp = MallProduct.new(mall_products_params)
    if mp.save!
      Image.change_image_url mp, params[:image_urls]
      flash[:success] = '添加商品成功！'
      redirect_to '/mall_products'
    else
      flash[:danger] = '添加商品失败！'
      redirect_to '/mall_products'
    end
  end

  def edit
    images = Image.get_image_url @mall_product
    @img_paths = images[:img_paths]
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@mall_product.thumbnail.to_s
    @thumbnail_path = @mall_product.thumbnail
  end

  def update
    ActiveRecord::Base.transaction do
      @mall_product.update_attributes!(mall_products_params)
      Image.change_image_url @mall_product, params[:image_urls]
    end
    flash[:success] = '修改商品成功！'
    redirect_to '/mall_products'
  end


  def destroy
    @mall_product.destroy
    flash[:danger] = '删除成功！'
    redirect_to '/mall_products'
  end

  def shelf
    if @mall_product.update_attributes!(is_mall_product: false)
      return render json: {status: 200, msg: 'succ'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def resort
    if @mall_product.update_attributes!(sort: params[:new_sort])
      return render json: {status: 200, msg: 'succ', data: @mall_product.sort}
    end
    return render json: {status: 500, msg: 'error'}
  end


  private

  def mall_products_params
    params.permit(:name, :market_price, :inventory_count,:exchange_type,:micro_ticket,:micro_score,
                  :postage, :thumbnail, :desc, :detail_url, :product_tag_id,:sku,:inventory_place)
  end

  def set_mall_product
    @product_tags = ProductTag.where(status: 0, delete_flag: false)
    @mall_product = BattleProduct.includes(:product_tag, :images).find(params[:id]) if params[:id]
  end

end
