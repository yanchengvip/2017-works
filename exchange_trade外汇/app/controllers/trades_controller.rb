class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update, :destroy, :trade_close]


  # 订单列表。
  #
  # GET /trades
  #
  # @param account_id [integer] 账号id
  # @param search [string] 搜索页面输入的搜索内容
  # @param [datetime] :start_at 日期(当是历史订单的时候传参)
  # @param [datetime] :end_at 日期(当是历史订单的时候传参)
  # @param type [integer] 持仓订单(1)/历史订单(2)
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{trades: Array<Trade>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    search = Trade.active.where(:account_id => Account.find_by(:name => params[:search])).order(created_at: :desc).paginate(:page => params[:page] || 1) if params[:search]
    if params[:type].to_i == 1
      trades = Trade.active.where(:account_id => params[:account_id], :close_time => "1970-01-01 00:00:00").order(created_at: :desc).paginate(:page => params[:page] || 1)
    else
      trades = Trade.active.where("account_id = ? and created_at >= ? and created_at<= ?", params[:account_id], params[:start_at], params[:end_at]).order(created_at: :desc).paginate(:page => params[:page] || 1)
    end
    if search
      render json: {status: 200, msg: "获取搜索订单列表成功", data: {trades: search.as_json}}
    else
      render json: {status: 200, msg: "获取订单列表成功", data: {trades: trades.as_json}}
    end
  end


  # 简单交易。
  #
  # POST /trades/trade_simple
  # @param [Hash] trade
  # @param [string] trade[symbol] 交易品种,字母表示
  # @param [string] trade[digits] 交易品种,数字表示
  # @param [integer] trade[cmd] 交易类型:0=买入(做多)，1=卖出(做空)
  # @param [double] trade[margin] 交易金额
  # @param [double] trade[sl] 止亏
  # @param [double] trade[tp] 止盈
  # @param [integer] trade[source] 订单来源 1=跟单，2=跟牛人,3=自主交易
  #
  # @return  ({status: 200,msg: '交易成功',data: {trade_id: 交易ID,margin: 实际交易金额， open_price: 单手价格, order_code: 订单号}}) 成功返回参数
  # @return  ({status: 500,msg: '交易失败,保证金不足',data: {}}) 失败返回参数
  # @return  ({status: 500,msg: '成交价格不能小于0',data: {}}) 失败返回参数
  # @author yancheng <cheng.yan@ihaveu.net>

  def trade_simple
    res = Trade.trade_simple @current_account, trade_params
    render json: res
  end


  # 复制跟单交易。
  #
  # POST /trades/trade_copy
  #
  # @param [Hash] trade
  # @param [string] trade[symbol] 交易品种,字母表示
  # @param [string] trade[digits] 交易品种,数字表示
  # @param [integer] trade[cmd] 交易类型:0=买入(做多)，1=卖出(做空)
  # @param [double] trade[volume] 交易手数
  # @param [integer] trade[trade_id] 跟单表trades的ID
  # @param [integer] trade[source] 订单来源 1=跟单，2=跟牛人,3=自主交易
  #
  # @return  ({status: 200,msg: '交易成功',data: {trade_id: 交易ID,margin: 实际交易金额， open_price: 单手价格, order_code: 订单号}}) 成功返回参数
  # @return  ({status: 500,msg: '手数不能为0',data: {}}) 失败返回参数
  # @return  ({status: 500,msg: '成交价格不能小于0',data: {}}) 失败返回参数
  # @return  ({status: 500, msg: '订单不能被复制，已平仓或者不是大师的订单', data: {}}) 失败返回参数
  # @author yancheng <cheng.yan@ihaveu.net>

  def trade_copy
    res = Trade.trade_copy @current_account, trade_params
    render json: res
  end


  # 平仓。
  #
  # POST /trades/trade_close
  #
  # @param [string] id 平仓订单的ID
  # @return  ({status: 200, msg: '平仓成功', data: {}}) 成功返回参数
  # @return  ({status: 500, msg: '平仓失败', data: {}}) 失败返回参数
  # @author yancheng <cheng.yan@ihaveu.net>
  def trade_close
    res = @trade.trade_close @current_account
    render json: res
  end

  # 跟牛单列表。
  #
  # GET /trades/master_order
  #
  # @param account_id [integer] 牛人id
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{trades: Array<Trade>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def master_order
    trades = Trade.active.where(:account_id => params[:account_id]).order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取跟牛单列表成功", data: {trades: trades.as_json}}
  end


  # 货币当日最低/最高价和涨跌点数、涨跌幅。
  #
  # POST /trades/currency_max_min_price
  #
  # @param [string] symbol 货币种类
  # @return  ({status: 200, msg: '成功', data: {day_count: 涨跌点数, day_limit: 涨跌幅, bid_min: 当日最低价, bid_max: 当日最高价}}) 成功返回参数
  # @return  ({status: 500, msg: '失败', data: {error: ''}}) 失败返回参数
  # @author yancheng <cheng.yan@ihaveu.net>
  def currency_max_min_price
    res = Trade.max_min_price params[:symbol]
    render json: res
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_trade
    @trade = Trade.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def trade_params
    params.require(:trade).permit(:account_id, :mt4_account, :sl, :tp, :source, :order_code, :symbol, :digits, :cmd, :volume, :open_time, :open_price, :trade_id, :margin, :dealer_id, :dealer_type1)
  end
end
