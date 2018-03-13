class RechargesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus7
  before_action :set_recharge

  def index
    params[:q][:battle_product_product_type_eq] = 1
    @q = MallOrder.active.where(status: [0, 1]).ransack(params[:q])
    @mall_orders = @q.result.includes(:user, :battle_product, :recharge).page(params[:page]).per(15)
  end

  def cancels
    @q = Recharge.active.where(status: -1).ransack(params[:q])
    @recharges = @q.result.includes(:user).page(params[:page]).per(15)
  end

  def confirm
    # ulr = UserLoginRecord.where(user_id: @recharge.user_id).limit(1)
    begin
      mall_order = MallOrder.find params[:confirm_id]
      ulr = UserLoginRecord.where("user_id = ? and login_type in ('ios', 'android')", mall_order.user_id).limit(1)
      if ulr.blank? && params[:confirm_status].to_i == 1
        return render json: {status: 500, msg: '该用户没有登录过APP！'}
      end

      @recharge = mall_order.get_recharge_record! current_user.id, params[:confirm_status].to_i
      if @recharge.status.in?([0, 3]) && params[:confirm_status].to_i == 1
        res = @recharge.order! current_user.id
        if res[:status]
          return render json: {status: 200, msg: '充值成功!'}
        else
          return render json: {status: 500, msg: '充值失败！!' + res[:msg]}
        end
      elsif @recharge.status.in?([0, 3, -1]) && params[:confirm_status].to_i == -1
        @recharge.update_attributes!(status: -1)
      end
      return render json: {status: 200, msg: '操作成功!'}
    rescue Exception => e
      return render json: {status: 500, msg: '操作失败，检查数据是否正确!' + e.to_s}
    end
  end

  # 手机
  def phone
    @q = Recharge.active.where(status: [1, 2, 3]).ransack(params[:q])
    @recharges = @q.result.includes(:user).page(params[:page]).per(15)
  end

  # 入场券
  def ticket
    params[:q][:battle_product_product_type_eq] = 2
    @q = MallOrder.active.ransack(params[:q])
    @mall_orders = @q.result.includes(:user, :battle_product).page(params[:page]).per(15)
  end

  # 兑奖券
  def coupons
    params[:q][:battle_product_product_type_eq] = 3
    @q = MallOrder.active.ransack(params[:q])
    @mall_orders = @q.result.includes(:user, :battle_product).page(params[:page]).per(15)
  end

  # 宝箱符
  def bxf
    params[:q][:battle_product_product_type_eq] = 4
    @q = MallOrder.active.ransack(params[:q])
    @mall_orders = @q.result.includes(:user, :battle_product).page(params[:page]).per(15)
  end

  # test
  def test_status
    @recharge.confirm_status!
    return redirect_to action: :phone
  end

  def phone_static
  end

  def cancels_reconfirm
    begin
      # mall_order = MallOrder.find params[:confirm_id]
      ulr = UserLoginRecord.where("user_id = ? and login_type in ('ios', 'android')", @recharge.user_id).limit(1)
      if ulr.blank? && params[:confirm_status].to_i == 1
        return render json: {status: 500, msg: '该用户没有登录过APP！'}
      end

      if @recharge.status.in?([-1]) && params[:confirm_status].to_i == 1
        res = @recharge.order! current_user.id
        if res[:status]
          return render json: {status: 200, msg: '充值成功!'}
        else
          return render json: {status: 500, msg: '充值失败！!' + res[:msg]}
        end
      elsif @recharge.status.in?([0, 3, -1]) && params[:confirm_status].to_i == -1
        @recharge.update_attributes!(status: -1)
      end
      return render json: {status: 200, msg: '操作成功!'}
    rescue Exception => e
      return render json: {status: 500, msg: '操作失败，检查数据是否正确!' + e.to_s}
    end
  end


  private
  def recharge_params
    params.require(:recharge).permit!
  end

  def set_recharge
    @recharge = Recharge.find(params[:id]) if params[:id]
  end

end
