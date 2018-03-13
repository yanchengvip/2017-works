class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :wechat_browser?, :can?
  before_action :init_params_search
  before_action :current_user, :login_filter
  before_action :header_menus
  #action = "resource#action" example: manage/user#show
  def can? action
    current_user && current_user.can?(action)
  end

  def wechat_browser?
    request.env["HTTP_USER_AGENT"].match("MicroMessenger")
  end

  def current_user
    begin
      # @currnet_user ||= User.find(session[:user_id])
      @currnet_user ||= Manage::Editor.find(session[:editor_id])
    rescue Exception => e
      nil
    end
  end

  def login_filter
    not_authorized and return if !authorized?
  end

  def authorized?
    can? "#{params[:controller]}##{params[:action]}"
  end

  # def current_account
  #   @current_account ||= Core::Account.find_by(token: request.env["HTTP_TOKEN"])
  # end

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

  # 初始化
  def init_params_search
    params[:q] ||= {}
    params[:q][:s] ||= "id desc"
  end

  # return flash_msg('success', '操作成功！', 'index')
  def flash_msg(type, msg, action)
    flash[type.to_sym] = msg
    if action
      return redirect_to action: action.to_sym
    end
  end

  # return flash_render('success', '操作成功！', 'index')
  def flash_render(type, msg, action)
    flash[type.to_sym] = msg
    if action
      return render action: action.to_sym
    end
  end

  # 错误消息
  def error_msg(obj)
    obj.errors.messages.map{|oem| (oem[0].to_s+oem[1][0])}.join(';')
  end

  private

  def show_menu menu
    if current_user
      menu.map{|x| x[:children] =  x[:children].select{|action| current_user.can? action[:action] }; x }.select{|x| x[:children].size > 0}
    else
      []
    end
  end

  def header_menus
    @header_menus = show_menu Menus::HeaderMenus.list
  end

  def side_menus1
    #内容管理菜单
    @side_menus = show_menu Menus::SideMenus.list[:menu1]
  end

  def side_menus2
    #商品菜单
    @side_menus = show_menu Menus::SideMenus.list[:menu2]
  end

  def side_menus3
    #订单管理
    @side_menus = show_menu Menus::SideMenus.list[:menu3]
  end

  def side_menus4
    #运营管理
    @side_menus = show_menu Menus::SideMenus.list[:menu4]
  end

  def side_menus5
    #供应商管理
    @side_menus = show_menu Menus::SideMenus.list[:menu5]
  end

  def side_menus6
    #权限管理
    @side_menus = show_menu Menus::SideMenus.list[:menu6]
  end

  def side_menus7
    #供应商商品菜单
    @side_menus = show_menu Menus::SideMenus.list[:menu7]
  end



end
