class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :check_auth, :current_user, :current_account


  def current_user
    begin
      @current_user ||= User.find(session[:user_id])
    rescue Exception => e
      @current_user = nil
    end
  end


  def current_account
    if current_user
      @current_account ||= current_user.accounts.where(dealer_id: session[:dealer_id]).first
    else
      @current_account = nil
    end

  end

  def check_auth


    unless request.headers["HTTP_TOKEN"].blank?
      session[:user_id] = User.active.where(token: request.headers["HTTP_TOKEN"]).where("token_time > '#{Time.now }'").first&.id
      if session[:user_id].blank?
        render json: {status: 406, msg: "授权失效，请重新登陆"} and return
      end
    else
      render json: {status: 406, msg: "授权失效，请重新登陆"} and return
    end

    session[:dealer_id] = Dealer.where(dealer_type: request.headers["HTTP_DEALERTYPE"]).first&.id
    session[:dealer_id] = Dealer.where(dealer_type: 1)&.id if session[:dealer_id].blank?
  end
end
