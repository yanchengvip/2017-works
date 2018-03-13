class ActivitiesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :set_activity
  before_action :side_menus
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @activities = Activity.active.page(params[:page]).per(15)
  end

  def show

  end

  def new
    if activity = Activity.active.first
      redirect_to action: 'edit', id: activity.id
    else
      @activity = Activity.new
    end
  end

  def create
    @activity = Activity.new(activity_params)
    ActiveRecord::Base.transaction do
      if @activity.save
        @activity.save_activity_items(params[:activity_items])
        flash['success'] = '添加免费宝箱成功！'
        return redirect_to action: :edit, id: @activity.id
      end
    end

    return flash_msg('danger', "添加免费宝箱失败！#{error_msg(@activity)}", 'new')
  end

  def edit

  end

  def update
    ActiveRecord::Base.transaction do
      if @activity.update(activity_params)
        @activity.update_activity_items(params[:activity_items])
        flash['success'] = '修改免费宝箱成功！'
        return redirect_to action: :edit, id: @activity.id
      end
    end

    flash['danger'] = '修改失败！'
    return redirect_to action: :edit, id: @activity.id
  end

  def destroy
    @activity.destroy
    return flash_msg('success', '操作成功！', 'index')
  end

  def item_form
    render partial: 'item_form', item_type_val: params[:item_type_val]
  end

  # 删除某个宝箱内容
  def destroy_item
    activity_item = ActivityItem.find_by(id: params[:activity_item_id].to_i)
    if activity_item && activity_item.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  private
  def activity_params
    params.permit(:status, :receive_hour, :receive_minute, :name)
  end

  def set_activity
    @activity = Activity.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu5]
  end

end
