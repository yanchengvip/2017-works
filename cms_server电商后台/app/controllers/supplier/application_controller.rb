class Supplier::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  helper_method :current_user
  before_action :current_user
  before_action :init_params_search
  layout "supplier/application"


  def current_user
    begin
      redirect_to "/supplier/session/new" and return  unless session[:provider_id]
      @current_user ||= Supplier::Provider.find(session[:provider_id])
      unless @current_user
        redirect_to "/supplier/session/new"
      else
        @current_user
      end
    rescue Exception => e
      p e
      not_authorized
    end
  end

  def not_authorized
    unless current_user
      redirect_to '/login'
    else
      respond_to do |format|
        format.html  { redirect_to '/403.html'}
        format.json  { render json: {status: 403, msg: 'not authorized', data: {}} }
      end
    end
  end

  # 错误消息
  def error_msg(obj)
    obj.errors.messages.map{|oem| (oem[0].to_s+oem[1][0])}.join(';')
  end

  # 初始化
  def init_params_search
    params[:q] ||= {}
    params[:q][:s] ||= "id desc"
  end
end
