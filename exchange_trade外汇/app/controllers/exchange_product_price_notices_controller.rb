class ExchangeProductPriceNoticesController < ApplicationController
  before_action :set_exchange_product_price_notice, only: [:show, :edit, :update, :destroy]

  # 外汇价格变动通知列表。
  #
  # GET /exchange_product_price_notices.json
  #
  # @param page [integer] 分页数, default: 1
  # @return ({data: Array<ExchangeProductPriceNotice> , status: 200, msg: 'success'})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>

  def index
    @exchange_product_price_notices =
    ExchangeProductPriceNotice.active.where(user_id: current_user.id).order(created_at: :desc).paginate(:page => params[:page])
    render json: {data: @exchange_product_price_notices.as_json(ExchangeProductPriceNotice.xml_options), status: 200, msg: 'success'}
  end


  # 创建外汇价格变动通知。
  #
  # POST /exchange_product_price_notices.json
  #
  # @param [string] exchange_product_price_notice[:exchange_product_id]  外汇品种id
  # @param [string] exchange_product_price_notice[:current_price]  当前价格
  # @param [string] exchange_product_price_notice[:up_price]  上涨价格
  # @param [string] exchange_product_price_notice[:down_price]  下跌价格
  # @param [string]exchange_product_price_notice[:up_price_percent]  上涨价格百分比
  # @param [string]exchange_product_price_notice[:ex_type] 价格变化类型 1 具体价格变化 2 价格百分比
  # @param [string] exchange_product_price_notice[:down_price_percent]  下跌价格百分比
  # @param [string] exchange_product_price_notice[:up_price_end_time]  上涨价格通知结束时间
  # @param [string] exchange_product_price_notice[:down_price_end_time]  下跌价格通知结束时间
  # @example { exchange_product_price_notice: { "exchange_product_id": 0, "current_price": 0.0, "up_price": 0.0, "down_price": 0.0, "up_price_end_time"=>"2017-08-29 16:26:01", "down_price_end_time"=>"2017-08-29 16:26:01",}}
  #
  # @return ({data: <ExchangeProductPriceNotice> , status: 200, msg: 'success'})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def create
    @exchange_product_price_notice = ExchangeProductPriceNotice.new(exchange_product_price_notice_params.merge(user_id: 1, dealer_id: 1))
    if @exchange_product_price_notice.save
      render json: {data: @exchange_product_price_notice, status: 200, msg: 'success'}
    else
      render json: {data: {}, status: 500, msg: "添加失败"}
    end
  end


  # DELETE /exchange_product_price_notices/1
  # DELETE /exchange_product_price_notices/1.json
  def destroy
    @exchange_product_price_notice.destroy
    respond_to do |format|
      format.html { redirect_to exchange_product_price_notices_url, notice: 'Exchange product price notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange_product_price_notice
      @exchange_product_price_notice = ExchangeProductPriceNotice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_product_price_notice_params
      params.require(:exchange_product_price_notice).permit(:user_id, :exchange_product_id, :current_price, :up_price, :down_price, :up_price_end_time, :down_price_end_time, :active, :up_notice, :down_notice, :notice_type, :up_price_percent, :down_price_percent, :ex_type)
    end
end
