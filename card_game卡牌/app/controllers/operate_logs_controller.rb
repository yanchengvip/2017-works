class OperateLogsController < ApplicationController
  before_filter :set_operate_log
  before_filter :side_menus3

  def index
    @q = OperateLog.ransack(params[:q])
    @operate_logs = @q.result.page(params[:page]).per(15)
  end

  private
  def set_operate_log
    @operate_log = OperateLog.find(params[:id]) if params[:id]
  end
end
