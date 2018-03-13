class FinancialRecordsController < ApplicationController
  before_action :set_financial_record, only: [:show, :edit, :update, :destroy]


  # 出入金记录列表。
  #
  # GET /financial_records.json
  #
  # @param [datetime] :created_at 日期
  # @param [fr_type] :fr_type 入金 1， 出金2
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{financial_records: Array<FinancialRecord>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    @financial_records = FinancialRecord.active.where("account_id = ? and fr_type = ? and created_at >= ?", @current_account.id, params[:fr_type], params[:created_at]).order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取出入金记录列表成功", data: {financial_records: @financial_records.as_json }}
  end


  #入金 / 出金
  #@note post 打开返回后的 data.url 进入出入金h5 页面
  #@param action [integer] 出入金 1 入金 2 出金, default: 出金
  #@return ({data:{ url: ""}, status: 200, msg:"success"})
  def wisdom_financial_record
    render json: Api::Wisdom.financial_record( current_account.login, current_account.id, params[:action].to_i)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_financial_record
      @financial_record = FinancialRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def financial_record_params
      params.require(:financial_record).permit(:account_id, :dealer_id, :amount, :balance, :dealer_type, :active)
    end
end
