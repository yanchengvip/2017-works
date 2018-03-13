class BookingTradesController < ApplicationController
  before_action :set_booking_trade, only: [:show, :edit, :update, :destroy]


  # 挂单列表。
  #
  # GET /booking_trades
  #
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{booking_trades: Array<BookingTrade>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    @booking_trades = BookingTrade.active.where(account_id: @current_account.id).order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取挂单列表成功", data: {booking_trades: @booking_trades.as_json}}
  end

  # 历史订单列表。
  #
  # GET /booking_trades/history_trades
  #
  # @param [datetime] :start_at 日期
  # @param [datetime] :end_at 日期
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{booking_trades: Array<BookingTrade>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def history_trades
    @booking_trades = BookingTrade.active.where("account_id = ? and created_at >= ?  and  created_at <= ?", 1, params[:start_at], params[:end_at]).order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取历史订单列表成功", data: {booking_trades: @booking_trades.as_json}}
  end

  # GET /booking_trades/1
  # GET /booking_trades/1.json
  def show
  end

  # GET /booking_trades/new
  def new
    @booking_trade = BookingTrade.new
  end

  # GET /booking_trades/1/edit
  def edit
  end

  # 挂单。
  #
  # POST /booking_trades
  # @param [Hash] booking_trade
  # @param [string] booking_trade[symbol] 交易品种,字母表示
  # @param [string] booking_trade[digits] 交易品种,数字表示
  # @param [double] booking_trade[volume] 手数
  # @param [double] booking_trade[price] 挂单价格
  # @param [double] booking_trade[sl] 止亏
  # @param [double] booking_trade[tp] 止盈
  # @param [integer] booking_trade[source] 订单来源 1=跟单，2=跟牛人,3=自主交易
  # @param [datatime] booking_trade[expire_time] 挂单有效期,没有则不填
  # @param [integer] booking_trade[trade_type]  2=买入(做多)，3=卖出(做空)
  #
  # @return  ({status: 200，msg: '挂单成功',data: {}}) 成功返回参数
  # @return  ({status: 500，msg: '挂单失败',data: {}}) 失败返回参数
  # @author yancheng <cheng.yan@ihaveu.net>
  def create
    msg = {status: 500, msg: "挂单失败！", data: {}}
    res = BookingTrade.booking_trade_create booking_trade_params,@current_account
    msg = {status: 200, msg: "挂单成功！", data: {}} if res
    render json: msg
  end

  # PATCH/PUT /booking_trades/1
  # PATCH/PUT /booking_trades/1.json
  def update
    respond_to do |format|
      if @booking_trade.update(booking_trade_params)
        format.html { redirect_to @booking_trade, notice: 'Booking trade was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking_trade }
      else
        format.html { render :edit }
        format.json { render json: @booking_trade.errors, status: :unprocessable_entity }
      end
    end
  end


  # 撤销挂单。
  #
  # DELETE /booking_trades/1
  #
  # @return ({data:{booking_trades: Array<BookingTrade>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def destroy
    res = {status: 500, msg: "删除失败,订单不属于此用户，或者订单状态不处于挂单中", data: {}}
    if @booking_trade.account_id == @current_account.id && @booking_trade.status != 0
      f = @booking_trade.update(:status => -1)
      res = {status: 200, msg: "删除成功", data: {}} if f
    end
    render json: res
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_booking_trade
    @booking_trade = BookingTrade.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def booking_trade_params
    params.require(:booking_trade).permit(:symbol,:digits,:volume,:price,:sl,:tp,:source,:expire_time,:trade_type)
  end
end
