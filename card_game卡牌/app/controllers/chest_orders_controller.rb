class ChestOrdersController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus10
  before_action :set_chest_order
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = ChestOrder.active.where(status: [0, 3]).ransack(params[:q])
    @chest_orders = @q.result.includes(:user).page(params[:page]).per(15)
  end

  def cancels
    @q = ChestOrder.active.where(status: -1).ransack(params[:q])
    @chest_orders = @q.result.includes(:user).page(params[:page]).per(15)
  end

  def confirm
    # ulr = UserLoginRecord.where(user_id: @chest_order.user_id).limit(1)
    ulr = UserLoginRecord.where("user_id = ? and login_type in ('ios', 'android')", @chest_order.user_id).limit(1)
    if ulr.blank? && params[:confirm_status].to_i == 1
      return render json: {status: 500, msg: '该用户没有登录过APP！'}
    end
    begin
      if @chest_order.status.in?([-1, 0, 3]) && params[:confirm_status].to_i == 1
        res = @chest_order.order! current_user.id
        if res[:status]
          return render json: {status: 200, msg: '充值成功!'}
        else
          return render json: {status: 500, msg: '充值失败！!' + res[:msg]}
        end
      elsif @chest_order.status.in?([0, 3]) && params[:confirm_status].to_i == -1
        @chest_order.update_attributes!(status: -1)
      end
      return render json: {status: 200, msg: '充值成功!'}
    rescue Exception => e
      return render json: {status: 500, msg: '充值失败！!' + e.to_s}
    end
  end

  def phone
    @q = ChestOrder.active.where(status: [1, 2, 3]).ransack(params[:q])
    @chest_orders = @q.result.includes(:user).page(params[:page]).per(15)
  end

  def qq
  end

  # test
  def test_status
    @chest_order.confirm_status!
    return redirect_to action: :phone
  end

  def phone_static
  end

  private

  def chest_order_params
    params.require(:chest_order).permit!
  end

  def set_chest_order
    @chest_order = ChestOrder.find(params[:id]) if params[:id]
  end


end
