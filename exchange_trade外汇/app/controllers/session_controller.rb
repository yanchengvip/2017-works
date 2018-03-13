class SessionController < ApplicationController
  skip_before_action :check_auth

  wechat_responder

  skip_before_action :verify_signature
  #发送验证码接口(带图片的)
  # GET/POST /session/verify_rucaptcha_phone_code
  # @param [string] :_rucaptcha  图片验证码
  # @param [string] :phone  电话
  #
  # @return ({status: 200, msg: ""})
  # @author wangxia <xia.wang01@ihaveu.net>
  def verify_rucaptcha_phone_code
    if verify_rucaptcha? && params["phone"] &&  params["phone"].match(/^1\d{10}$/)
      if ShortMessage.send_verification_code(params[:phone], request.remote_ip)
        render json: {status: 200, msg: "验证码已发送", data:{}}
      else
        render json: {status: 500, msg: "验证码发送频次过快，请稍后重试", data: {}}
      end
    else
      render json: {status: 500, msg: "验证码错误", data: {}}
    end
  end

  #发送验证码接口(不带图片的)
  # GET/POST /session/verify_phone_code
  # @param [string] :phone  电话
  #
  # @return ({status: 200, msg: ""})
  # @author wangxia <xia.wang01@ihaveu.net>
  def verify_phone_code
    if params["phone"] && params["phone"].match(/^1\d{10}$/)
      if ShortMessage.send_verification_code(params[:phone], params[:request_ip])
        render json: {status: 200, msg: "验证码已发送", data:{}}
      else
        render json: {status: 500, msg: "验证码发送频次过快，请稍后重试", data: {}}
      end
    else
      render json: {status: 500, msg: "手机号有误", data: {}}
    end
  end



  # 用户登录接口
  # POST /session/login
  # @param [string] :phone  手机号
  # @param [string] :password  密码
  #
  # @return ({status: 200, msg: ""})
  # @author wangxia <xia.wang01@ihaveu.net>
  def login
    user = User.active.find_by(phone: params[:phone])
    if user
      if user.verify_password(params[:password])
        session[:user_id] = user.id
        user.login(request)
        render json: {status: 200, msg: "登录成功", data: {user: user.as_json(User.xml_options)}}
      else
        render json: {status: 500, msg: "密码错误", data:{}}
      end
    else
      render json: {status: 500, msg: "用户不存在", data:{}}
    end
  end

  #用户微信登录接口
  #
  # POST /session/wx_auth
  # @param [string] code 微信授权后返回的code
  #
  # @return ({status: 200 / 201, msg: "登陆成功" / "微信授权成功，需绑定手机号", data: {user: <User>}})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def wx_auth
    wechat.jsapi_ticket.ticket if wechat.jsapi_ticket.oauth2_state.nil?
    params[:state] = wechat.jsapi_ticket.oauth2_state
    wechat_oauth2("snsapi_userinfo") do |openid, access_info|
      if wechat_user = WechatAccount.find_by(openid: openid)
        if @current_user = wechat_user.user
          session[:user_id] = @current_user.id
          @current_user.login(request)
          render json: {status: 200, msg: "登陆成功", data:{user: @current_user.as_json(User.xml_options)} }
        else
          render json: {status: 201, msg: "微信授权成功，需绑定手机号", data: {openid: openid} }
        end
      else
        userinfo = wechat.web_userinfo(access_info["access_token"], openid)
        wechat_user = WechatAccount.create(userinfo.with_indifferent_access.slice( :province, :openid, :nickname, :sex, :city, :country, :headimgurl, :unionid))
        render json: {status: 201, msg: "微信授权成功，需绑定手机号", data: {openid: openid} }
      end
    end
  end

end
