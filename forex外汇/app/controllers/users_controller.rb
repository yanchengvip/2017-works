class UsersController < ApplicationController
  skip_before_action :check_auth, only: [:create]

  #注册用户
  def create
    render json: {status: 502,msg: '交易协议必须勾选'} if params[:is_agree].to_i != 1 and return
    if Rails.cache.exist?("#{params[:phone]}:register_code") && Rails.cache.read("#{params[:phone]}:register_code") == params[:register_code] && params[:password] && params[:phone]
      if User.find_by(:phone => params[:phone])
        render json: {status: 500, msg: "该手机已经注册，请您直接登录", data: {}} and return
      else
        user = User.new(phone: params[:phone], password: params[:password], is_agree: params[:is_agree])
        if user.save!
          user.login_update(request)
          render json: {status: 200, msg: "注册成功", data: {token: user.token}}  and return
        end
      end
    else
      render json: {status: 501, msg: "注册码或密码错误！", data: {}} and return
    end
    render json: {status: 502, msg: "注册失败！", data: {}}
  end

  #修改用户信息
  def update
    if @current_user.update(user_params)
      render json: {status: 200, msg: "修改成功", data: {}}
    else
      render json: {status: 500, msg: "修改失败", error_detail: @current_user.errors.messages, data: {}}
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :email, :sex, :birthday, :desc,:address,:head_img)
  end
end
