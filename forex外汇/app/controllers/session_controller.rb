class SessionController < ApplicationController
  skip_before_action :check_auth

  #手机登录
  def phone_login
    user = User.active.find_by(phone: params[:phone])
    is_login,msg = false,'登录失败'
    if user
      if params[:login_type].to_i == 1 && user.verify_password(params[:password])
        #密码登录
        is_login = true
      else
        msg = '密码错误'
      end
      if params[:login_type].to_i == 2 && Rails.cache.read("#{params[:phone]}:login_code") == params[:login_code]
        #短信登录
        is_login = true
      else
        msg = '验证码错误'
      end
      if is_login
        session[:user_id] = user.id
        user.login_update(request)
        render json: {status: 200, msg: "登录成功", data: {user: {token: user.token, nickname: user.nickname, phone: user.phone, head_img: user.head_img}}}
      else
        render json: {status: 500, msg: msg, data: {}}
      end
    else
      render json: {status: 501, msg: "用户不存在", data: {}}
    end
  end

  #微信登录
  def wechat_login
    render json: {status: 200, msg: "登录成功", data: {}}
  end

  #忘记密码
  def forget_password
    user = User.active.where(phone: params[:phone]).first
    if user && params[:reset_code] && params[:reset_code] == Rails.cache.read("#{params[:phone]}:reset_code")
      user.password = params[:password]
      if user.save
        render json: {status: 200, msg: "修改成功", data: {}}
      else
        render json: {status: 500, msg: "修改失败", error_detail: user.errors.messages, data: {}}
      end
    else
      render json: {status: 501, msg: "用户不存在", data:{}}
    end
  end

  #短信验证码
  def send_verify_code
    phone = params[:phone]
    case params[:type].to_i
      when 1
        #发送注册码
        res = User.send_sms("#{phone}:register_code",phone)
      when 2
        #发送登录验证码
        res = User.send_sms("#{phone}:login_code",phone)
      when 3
        #重置密码时发送
        res = User.send_sms("#{phone}:reset_code",phone)
    end

    render json: res
  end


  def index

  end

end
