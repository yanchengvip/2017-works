class MallProductTagsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus7
  before_action :set_mall_product_tag
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    params[:q][:s] = 'order_num desc'
    @q = MallProductTag.active.ransack(params[:q])
    @mall_product_tags = @q.result.page(params[:page]).per(15)
  end

  def new
    @mall_product_tag = MallProductTag.new
  end

  def create
    mpt = MallProductTag.active.where(name: mall_product_tag_params[:name])
    if mpt.present?
      flash[:success] = '类别名称不能重复！'
      return render action: :new
    end

    mpt = MallProductTag.new(mall_product_tag_params)
    if mpt.save
      flash[:success] = '添加类别成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加类别失败！'
      return render action: :new
    end
  end

  def show
  end


  def edit;  end

  def update
    mpt = MallProductTag.active.where(name: mall_product_tag_params[:name]).first
    if mpt.present? && mpt.id != @mall_product_tag.id
      flash[:danger] = '类别名称不能重复！'
      return redirect_to action: :edit, id: @mall_product_tag.id
    end

    if @mall_product_tag.update_attributes(mall_product_tag_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @mall_product_tag.id
    end
  end


  def destroy
    flash[:success] = '分类标签已使用，不能被禁用！'
    b = BattleProduct.where(product_tag_id: @mall_product_tag.id)
    m = MallProduct.where(product_tag_id: @mall_product_tag.id)
    if b.empty? && m.empty? && params[:status].to_i == 1
      flash[:success] = '修改成功！'
      @mall_product_tag.update_attributes(status: params[:status])
    elsif params[:status].to_i == 0
      flash[:success] = '修改成功！'
      @mall_product_tag.update_attributes(status: 0)
    end

    redirect_to '/mall_product_tags'
  end

  def able
    if @mall_product_tag.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def mall_product_tag_params
    params.require(:mall_product_tag).permit(:name, :order_num, :status)
  end

  def set_mall_product_tag
    @mall_product_tag = MallProductTag.find(params[:id]) if params[:id]
  end


end
