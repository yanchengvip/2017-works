class ProductTagsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus7
  before_action :set_product_tag, only: [:destroy, :show, :edit, :update]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    params[:q][:s] = 'sort desc'
    @q = ProductTag.active.ransack(params[:q])
    @product_tags = @q.result.page(params[:page]).per(15)
  end

  def new
  end

  def create
    is_pt = ProductTag.where(name: params[:name])
    if is_pt.present?
      flash[:success] = '类别名称不能重复！'
      redirect_to '/product_tags/new' and return
    end

    pt = ProductTag.new(product_tag_params)
    if pt.save
      flash[:success] = '添加类别成功！'
    else
      flash[:success] = '添加类别失败！'
    end
    redirect_to '/product_tags'
  end


  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@product_tag.thumbnail&.to_s
    @thumbnail_path = @product_tag.thumbnail
  end

  def update
    is_pt = ProductTag.where(name: params[:name]).first
    if is_pt.present? && is_pt.id != @product_tag.id
      flash[:success] = '类别名称不能重复！'
      redirect_to "/product_tags/#{is_pt.first.id}/edit" and return
    end
    @product_tag.update_attributes(product_tag_params)
    flash[:success] = '修改成功！'
    redirect_to "/product_tags/#{@product_tag.id}/edit"
  end


  def destroy
    flash[:danger] = '分类标签已使用，不能被禁用！'
    b = BattleProduct.where(product_tag_id: @product_tag.id)
    m = MallProduct.where(product_tag_id: @product_tag.id)
    if b.empty? && m.empty? && params[:status].to_i == 1
      flash[:danger] = '修改成功！'
      @product_tag.update_attributes(status: params[:status])
    elsif params[:status].to_i == 0
      flash[:danger] = '修改成功！'
      @product_tag.update_attributes(status: 0)
    end

    redirect_to '/product_tags'
  end


  private

  def product_tag_params
    params.permit(:name, :sort, :status, :alias, :is_self, :max_user_num, :product_num, :energy_cost, :glory_gain, :thumbnail)
  end

  def set_product_tag
    @product_tag = ProductTag.find(params[:id])
  end


end
