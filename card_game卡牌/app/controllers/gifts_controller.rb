class GiftsController < ApplicationController
  before_filter :set_gift
  before_action :side_menus
  before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = Gift.active.ransack(params[:q])
    @gifts = @q.result.page(params[:page]).per(15)
  end

  def show

  end

  def new
    @gift = Gift.new
  end

  def create
    @gift = Gift.new(gift_params)
    ActiveRecord::Base.transaction do
      if @gift.save
        @gift.save_gift_items(params[:gift_items])
        flash['success'] = '添加赠品成功！'
        return redirect_to action: :index
      end
    end

    return flash_msg('danger', "添加赠品失败！#{error_msg(@gift)}", 'new')
  end

  def edit

  end

  def update
    ActiveRecord::Base.transaction do
      if @gift.update(gift_params)
        @gift.update_gift_items(params[:gift_items])
        flash['success'] = '修改赠品成功！'
        return redirect_to action: :index
      end
    end

    flash['danger'] = '修改失败！'
    return redirect_to action: :edit, id: @gift.id
  end

  def destroy
    @gift.destroy
    return flash_msg('success', '操作成功！', 'index')
  end

  def item_form
    render partial: 'item_form', item_type_val: params[:item_type_val]
  end

  # 删除某个宝箱内容
  def destroy_item
    gift_item = GiftItem.find_by(id: params[:gift_item_id].to_i)
    if gift_item && gift_item.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end


  private
  def gift_params
    params.permit(:status, :name, :operator)
  end

  def set_gift
    @gift = Gift.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end
end
