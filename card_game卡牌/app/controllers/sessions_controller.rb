class SessionsController < ApplicationController
  skip_before_action :authenticate_user, except: [:destroy]
  skip_before_action :verify_authenticity_token

  def index

  end

  def create
    if  params["login_name"] && params["password"]
      if admin = Admin.login(params["login_name"], params["password"])
        if !admin.in_use?
          flash[:danger] = '你的账号已被禁用，没有登录权限！'
          redirect_to '/login' and return
        end

        if admin.is_admin?
          #管理员
          session[:admin_id] = admin.id
          admin.update_attributes!(request_ip: request.remote_ip, last_login_time: Time.now)
          return redirect_to root_url
        end
        flash[:danger] = '用户不是管理员，没有登录权限！'
        redirect_to '/login' and return
      end
    end

    flash[:danger] = '用户名或密码错误！'
    redirect_to '/login'
  end

  def destroy
    session[:admin_id] = nil
    redirect_to '/login'
  end

end
