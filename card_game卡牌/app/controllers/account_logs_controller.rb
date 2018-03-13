class AccountLogsController < ApplicationController
  #authorize_resource :class => false,:only => [:index]
  before_action :side_menus6

  def index
    if params[:create_time_begin].present? && params[:create_time_end].present?
      @account_logs = AccountLog.active.where('create_time >= ? and create_time <= ?',params[:create_time_begin],params[:create_time_end]).page(params[:page]).per(15)
    else
      @account_logs = AccountLog.active.page(params[:page]).per(15)
    end
  end
end
