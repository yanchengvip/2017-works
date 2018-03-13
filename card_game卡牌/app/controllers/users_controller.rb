require 'csv'
class UsersController < ApplicationController
  #authorize_resource :class => false,:only => [:index]
  before_action :side_menus5

  def index
    if params[:create_time_begin].present? && params[:create_time_end].present?
      @users = User.active.where('create_time >= ? and create_time <= ?',params[:create_time_begin],params[:create_time_end]).page(params[:page]).per(15)
    else
      @users = User.active.page(params[:page]).per(15)
    end
  end

  def user_login_first
    @q = UserLoginFirst.ransack(params[:q]).result
    @ulfs = @q.page(params[:page]).per(15)
    @total_count = UserLoginFirst.ransack(params[:q]).result.count

    if request.format.symbol == :csv
       csv_data = CSV.generate do |csv|
         csv <<  ["\xEF\xBB\xBFAPP版本","设备类型", "设备ID ", "创建时间"]
         @q.each do |ulf|
           csv << [ulf.app_version, ulf.app_type, ulf.device_id, ulf.created_at&.strftime("%Y-%m-%d %H:%m:%S")]
         end
       end
    end
    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end


end
