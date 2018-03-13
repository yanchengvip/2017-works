class MallOrdersController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :side_menus4
  before_action :side_menus6, only: [:csv_index]
  before_action :set_mall_order, only: [:edit, :update]
  skip_before_action :verify_authenticity_token, only: [:update]

  def index
    # @mall_orders = MallOrder.show_index params
    @q = MallOrder.active.where(order_type: 3).ransack(params[:q])
    @mall_orders = @q.result.page(params[:page]).per(15)
  end
  def csv_index
    index
  end

  def edit

  end

  def update
    @mall_order.update_attributes(mall_order_params)
    flash[:danger] = '修改成功！'
    redirect_to '/mall_orders/'+@mall_order.id.to_s+'/edit'
  end

  private


  def set_mall_order
    @mall_order = MallOrder.active.find(params[:id])
  end

  def mall_order_params
    params.permit(:status, :logistics_company, :logistics_num, :postcode)
  end
end
