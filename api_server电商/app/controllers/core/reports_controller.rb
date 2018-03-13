class Core::ReportsController < ApplicationController

  # 添加用户反馈
  # POST /core/reports
  # @param [Hash] core_report 用户反馈
  # @param [string] report[reason]  原因
  # @param [string]  report[description] 说明
  # @param [string]  report[url] url
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    params[:report].merge!(user_id: current_user[:id].to_i)
    core_repost = Core::Report.insert params[:report]
    render json: {status: core_repost[:comm][:code].to_i, msg: core_repost[:comm][:msg], data: {core_repost: core_repost[:data]}}
  end



  private


    # Never trust parameters from the scary internet, only allow the white list through.
    def core_report_params
      params.fetch(:core_report, {})
    end
end
