class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  helper_method :current_user, :wechat_browser?, :current_account

  before_action :login_filter
  # rescue_from Exception do |e|
  #   e.backtrace.map{|x| Rails.logger.error x}
  #   render json: {status: 500, data:{}, msg: "system error"} if Rails.env == 'production'
  # end

  #判断是否是微信浏览器
  def wechat_browser?
    request.env["HTTP_USER_AGENT"].match("MicroMessenger")
  end

  #当前用户 Auction::User
  def current_user
    begin
      current_account
      # @currnet_user ||= Auction::User.where(id: current_account[:id]).first
    rescue Exception => e
      nil
    end
  end

  #检查是否需要登录
  def login_filter
    session[:user_login_on] = Date.today.to_s if session[:user_login_on] != Date.today.to_s
    if !authorized?
      if wechat_browser?
        wx_auth
      else
        not_authorized and return
      end
    end
  end

  #接口只验证是否登录
  def authorized?
    if need_login?
      return !current_token.blank? && current_account && current_user
    end
    true
  end

  #检查接口是否需要登录
  def need_login?
     ["show_auction_users", "create_auction_trades","show_auction_trades","index_auction_trades",
      "cancel_auction_trades","receive_auction_trades","delivery_query_auction_trades",
      "confirm_products_list_auction_trades","amounts_auction_trades","express_auction_trades",
      "pay_list_auction_trades","return_auction_units","return_detail_auction_trades",
      "index_auction_contacts","destroy_core_sessions",
     "create_auction_contacts", "show_auction_contacts",
     "update_acution_contacts", "destroy_auction_contacts",
     "default_contact_auction_contacts", "set_default_contact_auction_contact",
     "index_auction_fanships", "create_auction_fanships",
     "destroy_auction_fanships", "is_collect_auction_fanships",
     "index_auction_favorites", "create_auction_favorites",
     "destroy_auction_favorites", "is_collect_auction_favorites",
    "index_auction_vouchers", "update_acution_vouchers", "create_core_reports",
    "index_retail_carts","create_retail_carts","destroy_retail_carts"].include? "#{params[:action]}_#{params[:controller].to_s.underscore.gsub('/', '_')}"
  end

  def wx_auth
    Rails.logger.info("*"*100)
    Rails.logger.info(params)
    wechat_oauth2("snsapi_userinfo") do |openid, access_info|
      connection = Core::Connection.where(openid: openid, site: "wechat").first
      if connection
        #注册过账户
        if core_account = Core::Account.where(id: connection[:account_id]).first
          user = Core::User.where(id: connection_union_account.id).first
        else
          user, core_account = create_account connection, access_info
        end
      else #没有账户 首次微信登陆
        connection = Core::Connection.create(site: "wechat", identifier: openid, active: true)
        user, core_account = create_account connection, access_info
      end
      session[:account_id] = core_account[:id]
      # render json: {status: 200, msg: 'success', data: {user: user, account: core_account }}
    end
  end

  #创建账户
  def create_account connection, access_info
    userinfo = wechat.web_userinfo(access_info["access_token"], openid)
    connection_union = Core::Connection.where(union_id: connection[:union_id], active: true, identifier: connection[:identifier]).first
    connection_union_account = Core::Account.where(id: connection_union[:account_id]).first
    unless connection_union.blank? || connection_union_account.blank?
      connection.update(account_id: connection_union.account_id)
      @user = Core::User.where(id: connection_union_account.id).first
    else
      @account = Core::Account.create(ip_address: request.remote_ip, link_id: cookies[:link_id], click_id: cookies[:click_id])
      @user = Core::User.create(name: connection[:name], id: @account[:id])
    end
    return [@user, @account || connection_union_account ]
  end



  #当前账户 Core::Account
  def current_account
    @current_account ||= get_current_account
  end

  def current_token
    request.env["HTTP_TOKEN"] || params[:token]
  end

  def get_current_account
    token = {
      "token": current_token
    }
    account = Core::Account.token token
    if account[:data] && account[:data][:core_account]
      current_account = account[:data][:core_account]
    else
      current_account = nil
    end
    current_account
  end

  #返回未登录json
  def not_login
    respond_to do |format|
      format.json  { render json: {status: 403, msg: 'not login', data: {}}}
    end
  end

  #返回禁止访问json 1 未登录访问用户数据， 2登录 访问非自己的用户数据
  def not_authorized
    respond_to do |format|
      format.json  { render json: {status: 403, msg: 'not authorized', data: {}}}
    end
  end

end
