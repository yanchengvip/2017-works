class ExtremeChestsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :set_extreme_chest
  before_action :side_menus
  # before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = ExtremeChest.active.ransack(params[:q])
    @extreme_chests = @q.result.page(params[:page]).per(15)
  end

  def show

  end

  def new
    @extreme_chest = ExtremeChest.new
  end

  def create
    if !ExtremeChest.active.blank?
      return flash_msg('danger', "添加至尊宝箱失败，只能有一个至尊宝箱！", 'index')
    end

    @extreme_chest = ExtremeChest.new(extreme_chest_params)
    ActiveRecord::Base.transaction do
      if @extreme_chest.save
        @extreme_chest.save_extreme_chest_items(params[:extreme_chest_items])
        flash['success'] = '添加至尊宝箱成功！'
        return redirect_to action: :index
      end
    end

    return flash_msg('danger', "添加至尊宝箱失败！#{error_msg(@extreme_chest)}", 'new')
  end

  def edit

  end

  def update
    ActiveRecord::Base.transaction do
      if @extreme_chest.update(extreme_chest_params)
        @extreme_chest.update_extreme_chest_items(params[:extreme_chest_items])
        flash['success'] = '修改至尊宝箱成功！'
        return redirect_to action: :index
      end
    end

    flash['danger'] = '修改失败！'
    return redirect_to action: :edit, id: @extreme_chest.id
  end

  def destroy
    if @extreme_chest.destroy
      return flash_msg('success', '删除成功！', 'index')
    else
      return flash_msg('danger', '删除失败！', 'index')
    end
  end

  def item_form
    render partial: 'item_form', item_type_val: params[:item_type_val]
  end

  # 删除某个宝箱内容
  def destroy_item
    extreme_chest_item = ExtremeChestItem.find_by(id: params[:extreme_chest_item_id].to_i)
    if extreme_chest_item && extreme_chest_item.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  private
  def extreme_chest_params
    params.permit(:status, :refresh_time, :card_count, :name)
  end

  def set_extreme_chest
    @extreme_chest = ExtremeChest.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu5]
  end

end
