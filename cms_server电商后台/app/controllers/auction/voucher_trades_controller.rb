class Auction::VoucherTradesController < ApplicationController
  before_action :side_menus3
  def index
    @bread_menu = {m1: '优惠券订单', m2: '优惠券订单', m2_url: '/auction/voucher_trades', m3: '优惠券订单列表', s: 'vouche_trades_search'}
    @score_items = Auction::ScoreItem.active.includes(:table).ransack(params[:q]).result.page(params[:page]).per(15)

    # ._where(params[:where])._order(params[:order]).paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html {render :score_items}
    end
  end

  def notify_drp_service
    @score_item = Auction::ScoreItem.find(params[:id])
    if @score_item.notify_drp_service
      flash_msg('success', "同步成功", 'index')
      # render json:{status: 200, msg: "增加成功", data:{drp_server_trade_no: @score_item.drp_server_trade_no}}
    else
      flash_msg('danger', "同步失败", 'index')
      # render json:{status: 500, msg: "增加微积分失败，请联系开发人员"}
    end
  end
end
