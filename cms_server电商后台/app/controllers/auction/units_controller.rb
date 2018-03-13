class Auction::UnitsController < ApplicationController
  before_action :set_auction_unit, only: [:show, :audit, :transfer, :freezed, :apply_refund]
  skip_before_action :verify_authenticity_token
  before_action :side_menus3
  skip_before_action :current_user, :login_filter, only: [:collapse_table]

  def show
  end


  #申请退货
  def apply_refund
    flash[:error] = '申请退货失败'
    if !@auction_unit.status.present?
      ActiveRecord::Base.transaction do
        @auction_unit.update_attributes!(auction_unit_params.merge(status: 'audit', request_at: Time.now))
        @auction_unit.unit_refund_logs.create!(editor_id: current_user.id, status: 'audit', remark: params[:remark], user_id: @auction_unit.trade.user_id)
        flash[:success] = '申请退货成功'
      end
    else
      flash[:error] = '没有权限'
    end
    redirect_to returns_auction_supplier_trades_path
  end

  #审核
  def audit
    flash[:error] = '审核失败'
    if @auction_unit.status == 'audit'
      ActiveRecord::Base.transaction do
        if params[:status] == 'receive'
          flash[:success] = '审核成功'
          status = 'receive'
        elsif params[:status] == 'freezed'
          flash[:success] = '驳回退货成功'
          status = nil #驳回后unit状态改为初始值，可以再次发起退货
        end
        @auction_unit.update_attributes!(status: status, audit_at: Time.now, audit_editor_id: current_user.id)
        @auction_unit.unit_refund_logs.create!(editor_id: current_user.id, status: params[:status], remark: params[:remark], user_id: @auction_unit.trade.user_id)

      end
    else
      flash[:error] = '没有权限'
    end
    redirect_to returns_auction_supplier_trades_path
  end

  #退款
  def transfer
    flash[:error] = '退款失败'
    if @auction_unit.status == 'transfer'
      ActiveRecord::Base.transaction do
        @auction_unit.update_attributes(status: 'complete', transfer_at: Time.now, transfer_editor_id: current_user.id)
        @auction_unit.unit_refund_logs.create!(editor_id: current_user.id, status: 'complete', remark: params[:remark], user_id: @auction_unit.trade.user_id)
        flash[:success] = '退款成功'
      end
    else
      flash[:error] = '没有权限'
    end
    redirect_to returns_auction_supplier_trades_path
  end

  #冻结
  def freezed
    flash[:error] = '冻结失败'
    if @auction_unit.status == 'transfer'
      remark = @auction_unit.remark.present? ? @auction_unit.remark.to_s + ';'+ params[:remark] : params[:remark]
      @auction_unit.update_attributes(status: 'freezed', remark: remark, freeze_at: Time.now, freeze_editor_id: current_user.id)
      flash[:success] = '冻结成功'
    else
      flash[:error] = '没有权限'
    end
    redirect_to returns_auction_supplier_trades_path
  end


  #订单列表中展示商品详情的table
  def collapse_table
    if params[:type] == '1'
      @units = Auction::Unit.includes(:product, :provider, :auction_sku).where(trade_id: params[:id])
    elsif params[:type] == '2'
      @units = Auction::Unit.includes(:product, :provider, :auction_sku).where(supplier_trade_id: params[:id])
    end
    render partial: 'collapse_table'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_auction_unit
    @auction_unit = Auction::Unit.includes(:trade).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def auction_unit_params
    params.permit(:return_reason, :amount_returned, :return_phone, :return_account, :return_name, :return_province, :return_city, :return_branch, :remark)
  end
end
