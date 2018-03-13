class Core::SessionsController < ApplicationController
  # 账号退出登录接口
  # DELETE /core/sessions/1
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def destroy
    result = Core::Session.logout({id: current_user[:id]})
    render json: {status: result[:comm][:code].to_i, msg: result[:comm][:msg], data: {}}
  end

  def current_time
    render json: {current_time: Time.now.strftime("%Y-%m-%d %H:%M:%S")}
  end


  # 用户登录接口
  # POST /session/login
  # @param [string] :phone  手机号
  # @param [string] :password  密码
  #
  # @return ({status: 200, msg: ""})
  # @author wangxia <xia.wang01@ihaveu.net>
  def login
    result = Core::Session.login params
    if result[:comm][:code] == "200"
      session[:user_id] = result[:data][:auction_user][:id]
      render json: {status: result[:comm][:code].to_i, msg: result[:comm][:msg], data: {phone: result[:data][:phone], auction_user: result[:data][:auction_user],core_account: result[:data][:core_account] }}
    else
      render json: {status: result[:comm][:code].to_i, msg: result[:comm][:msg], data: {}}
    end

  end

end
