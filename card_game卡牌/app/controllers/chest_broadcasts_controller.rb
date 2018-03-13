class ChestBroadcastsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus10
  before_action :set_chest_broadcast
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = ChestBroadcast.active.ransack(params[:q])
    @chest_broadcasts = @q.result.page(params[:page]).per(15)
  end

  def show;end

  def new
    @chest_broadcast = ChestBroadcast.new
  end

  def create
    @chest_broadcast = ChestBroadcast.new(chest_broadcast_params.merge(admin_id: current_user.id))
    if @chest_broadcast.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    end
    flash[:danger] = '添加失败！'
    return render action: :new
  end

  def edit;end

  def update
    if @chest_broadcast.update_attributes!(chest_broadcast_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    end
    flash[:danger] = '修改失败！'
    return redirect_to action: :edit, id: @chest_broadcast.id
  end

  def destroy
    if @chest_broadcast.destroy
      flash[:success] = '删除成功！'
    else
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def shelf
    if @chest_broadcast.update_attributes(published: params[:shelf_status])
      return render json: {status: 200, msg: '操作成功'}
    else
      return render json: {status: 500, msg: "操作失败"}
    end
  end

  private

  def chest_broadcast_params
    params.require(:chest_broadcast).permit!
  end

  def set_chest_broadcast
    @chest_broadcast = ChestBroadcast.find(params[:id]) if params[:id]
  end


end
