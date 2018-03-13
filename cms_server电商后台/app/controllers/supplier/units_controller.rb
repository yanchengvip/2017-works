class Supplier::UnitsController < Supplier::ApplicationController
  def index
    params[:q] ||= {}
    params[:q][:s] ||= "id desc"
    @units = Auction::Unit.includes(:trade).where(provider_id: current_user.id).ransack(params[:q]).result.page(params[:page] || 1)
  end

  def receive
    @unit = Auction::Unit.where(id: params[:id], provider_id: current_user.id).first
    if @unit && @unit.status == "receive" && %w[audit blocked prepare ship receive complete].include?(@unit.trade.status)
      @unit.returnit!(:receive_editor_id => @current_user.id, :receive_at => Time.now, :status => 'transfer')
      render json: {status: 200, msg: "success", data:{}}
    else
      render json: {status: 500, msg: "订单状态异常，不可退货", data:{}}
    end
  end
end
