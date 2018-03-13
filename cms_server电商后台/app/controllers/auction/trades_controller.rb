class Auction::TradesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:audit, :freezed]
  before_action :set_auction_trade, only: [:show, :update, :audit, :freezed]
  before_action :side_menus3

  def index
    @bread_menu = {m1: '订单管理', m2: '订单列表', m2_url: '/auction/trades', s: 'trade_search'}
    @tab = params[:tab].nil? ? 1 : params[:tab]
    @trade_lists = Auction::TradeList.includes(:auction_trade, :supplier_trade, :account, :contact).active
                  .ransack(params[:q]).result
                  .order(created_at: :desc).page(params[:page]).per(20)
  end


  def show
    @bread_menu = {m1: '订单管理', m2: '订单列表', m2_url: '/auction/trades', m3: '订单详情'}
    @supplier_trades = @auction_trade.supplier_trades.includes(:account, :auction_trade, :units,
                                                               :contact, :provider, :auction_products, :auction_skus)
  end


  def update
    if @auction_trade.update(auction_trade_params)
      redirect_to @auction_trade, notice: '修改成功'

    else
      redirect_to @auction_trade, notice: '修改失败'
    end
  end

  #审核
  def audit
    @auction_trade.separate_trade params,current_user
    flash[:success] = '审核订单成功'
    Auction::Sm.create(phone: @auction_trade.delivery_phone, content: Setting.audit_msg)
    # SendMsgJob.set(wait: 1.seconds).perform_later([@auction_trade.contact&.phone], Setting.audit_msg)
    redirect_to auction_trades_path
  end

  #冻结
  def freezed
    @auction_trade.update_attributes(status: 'freezed', freeze_at: Time.now, freeze_editor_id: '')
    @auction_trade.status_log('freezed',params[:remark],current_user)
    flash[:success] = '冻结订单成功'
    redirect_to auction_trades_path
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_auction_trade
    @auction_trade = Auction::Trade.includes(:account, :contact).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def auction_trade_params
    params.require(:auction_trade).permit(:status, :delivery_phone, :delivery_service)
  end

  def audit_and_freezed
    @auction_trade = Auction::Trade.includes(:account, :contact).find(params[:id])
    if @auction_trade.status != 'audit'
      flash[:error] = '订单状态不处于待审核状态，因此修改状态失败！'
      redirect_to auction_trades_path
    end
  end
end
