class ApplicationController < ActionController::Base
  include CancancanAuthorizeResource
  protect_from_forgery with: :exception
  before_action :authenticate_user
  before_action :init_params_search
  before_action :side_bg
  helper_method :current_user


  def authenticate_user
    return if current_user && current_user.in_use?
    login_auth
  end

  def current_user
    begin
      @current_user ||= Admin.includes(:admin_roles).find(session[:admin_id])
      if @current_user.blank? || @current_user.admin_roles.blank?
        return nil
      end
      @current_user
    rescue Exception => e
      nil
    end
  end

  def login_auth
    redirect_to '/login'
  end

  # return flash_msg('success', '操作成功！', 'index')
  def flash_msg(type, msg, action)
    flash[type.to_sym] = msg
    if action
      redirect_to action: action.to_sym
    end
  end

  # return flash_render('success', '操作成功！', 'index')
  def flash_render(type, msg, action)
    flash[type.to_sym] = msg
    if action
      render action: action.to_sym
    end
  end

  # 错误消息
  def error_msg(obj)
    obj.errors.messages.map{|oem| (oem[0].to_s+oem[1][0])}.join(';')
  end

  # 初始化参数
  def init_params_search
    params[:q] ||= {}
    params[:q][:s] ||= "id desc"
  end

  def side_bg
    session['side_bg'] = cookies[:side_bg]
    # cookies[:side_bg] = nil
  end


  private

  def side_menus1
    #战场管理菜单
    @side_menus = Menus::SideMenus.list[:menu1]
  end

  def side_menus2
    #能量商城
    @side_menus = Menus::SideMenus.list[:menu2]
  end

  def side_menus3
    #系统管理菜单
    @side_menus = Menus::SideMenus.list[:menu3]
  end
  def side_menus4
    #奇珍商城
    @side_menus = Menus::SideMenus.list[:menu4]
  end

  def side_menus5
    @side_menus = Menus::SideMenus.list[:menu5]
  end

  def side_menus6
    #报表
    @side_menus = Menus::SideMenus.list[:menu6]
  end

  #商品管理
  def side_menus7
    @side_menus = Menus::SideMenus.list[:menu7]
  end

  #统计
  def side_menus8
    @side_menus = Menus::SideMenus.list[:menu8]
  end

  #统计
  def side_menus9
    @side_menus = Menus::SideMenus.list[:menu9]
  end

  #宝箱
  def side_menus10
    @side_menus = Menus::SideMenus.list[:menu10]
  end

  #红包
  def side_menus11
    @side_menus = Menus::SideMenus.list[:menu11]
  end

  #财神
  def side_menus12
    @side_menus = Menus::SideMenus.list[:menu12]
  end


end
