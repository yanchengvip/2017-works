class ProductTypesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus4
  before_action :set_product_type, only: [:destroy, :show, :edit, :update]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    conditions = []
    values = []
    if params[:name].present?
      conditions << 'name like ?'
      values << "%#{params[:name]}%"
    end
    @product_types = ProductType.where(conditions.join(' and '), *values).order('created_at desc')
                        .active.page(params[:page]).per(20)
  end

  def new
  end

  def create
    is_pt = ProductType.where(name: params[:name])
    if is_pt.present?
      flash[:success] = '类别名称不能重复！'
      redirect_to '/product_types/new' and return
    end

    pt = ProductType.new(product_type_params)
    if pt.save
      flash[:success] = '添加类别成功！'
    else
      flash[:success] = '添加类别失败！'
    end
    redirect_to '/product_types'
  end


  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@product_type.thumbnail&.to_s
    @thumbnail_path = @product_type.thumbnail
  end

  def update
    is_pt = ProductType.where(name: params[:name]).first
    if is_pt.present? && is_pt.id != @product_type.id
      flash[:success] = '类别名称不能重复！'
      redirect_to "/product_types/#{is_pt.first.id}/edit" and return
    end
    @product_type.update_attributes(product_type_params)
    flash[:success] = '修改成功！'
    redirect_to "/product_types/#{@product_type.id}/edit"
  end


  def destroy
    flash[:success] = '分类标签已使用，不能被禁用！'
    b = BattleProduct.where(product_type_id: @product_type.id)
    m = MallProduct.where(product_type_id: @product_type.id)
    if b.empty? && m.empty? && params[:status].to_i == 1
      flash[:success] = '修改成功！'
      @product_type.update_attributes(status: params[:status])
    elsif params[:status].to_i == 0
      flash[:success] = '修改成功！'
      @product_type.update_attributes(status: 0)
    end

    redirect_to '/product_types'
  end


  private

  def product_type_params
    params.permit(:name, :sort, :status)
  end

  def set_product_type
    @product_type = ProductType.find(params[:id])
  end


end
