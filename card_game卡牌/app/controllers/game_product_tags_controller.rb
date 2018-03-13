class GameProductTagsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus7
  before_action :set_game_product_tag
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    params[:q][:s] = 'order_num desc'
    @q = GameProductTag.active.ransack(params[:q])
    @game_product_tags = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @game_product_tag = GameProductTag.new
  end

  def create
    gpt = GameProductTag.active.where(name: game_product_tag_params[:name])
    if gpt.present?
      flash[:success] = '类别名称不能重复！'
      return render action: :new
    end

    gpt = GameProductTag.new(game_product_tag_params)
    if gpt.save
      flash[:success] = '添加类别成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加类别失败！'
      return render action: :new
    end
  end


  def edit; end

  def update
    gpt = GameProductTag.active.where(name: game_product_tag_params[:name]).first
    if gpt.present? && gpt.id != @game_product_tag.id
      flash[:danger] = '类别名称不能重复！'
      return redirect_to action: :edit, id: @game_product_tag.id
    end

    if @game_product_tag.update_attributes(game_product_tag_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @game_product_tag.id
    end
  end


  def destroy
    flash[:success] = '分类标签已使用，不能被禁用！'
    b = BattleProduct.where(product_tag_id: @game_product_tag.id)
    m = MallProduct.where(product_tag_id: @game_product_tag.id)
    if b.empty? && m.empty? && params[:status].to_i == 1
      flash[:success] = '修改成功！'
      @game_product_tag.update_attributes(status: params[:status])
    elsif params[:status].to_i == 0
      flash[:success] = '修改成功！'
      @game_product_tag.update_attributes(status: 0)
    end

    redirect_to '/game_product_tags'
  end

  def able
    if @game_product_tag.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def game_product_tag_params
    params.require(:game_product_tag).permit(:name, :order_num, :status)
  end

  def set_game_product_tag
    @game_product_tag = GameProductTag.find(params[:id]) if params[:id]
  end


end
