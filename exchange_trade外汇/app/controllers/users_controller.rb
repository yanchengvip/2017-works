class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :destroy]
  skip_before_action :check_auth, only: [:bind_phone]

  #用户详情页面
  # GET /users/1
  # GET /users/1.json
  def show
    user = User.acquire(@current_user.id)
    render json: {status: 200, msg: "获取用户详情信息成功", data: {user: user.as_json}}
  end


  #用户注册接口
  # POST /users
  # @note 图形验证码地址 /rucaptcha
  # @param [string] :phone 手机号
  # @param [string] :_rucaptcha 验证码
  # @param [string] :message_code 短信验证码
  # @param [string] :password 密码
  # @param [string] :confirm_password 确认密码
  # @param [string] :is_agree 是否同意协议
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    if verify_rucaptcha? && params[:message_code] &&  params[:message_code] == Rails.cache.read(phone) && params["password"] && params["phone"] &&  params["phone"].match(/^1\d{10}$/) && params[:password] == params[:confirm_password] && params[:is_agree] == '1'
      if User.find_by(:phone => params[:phone])
        render json: {status: 500, msg: "该手机已经注册，请您直接登录", data: {}}
      else
        user = User.new(phone: params[:phone], password_digest: params[:password], is_agree: params[:is_agree])
        if user.save
          render json: {status: 200, msg: "注册成功", data: {}}
        end
      end
    else
      render json: {status: 500, msg: "验证码输入错误.短信验证码输入错误", data: {}}
    end
  end

  #用户忘记密码修改密码接口
  # POST /users/forget_password
  # @param [string] :phone  手机号
  # @param [string] :message_code  验证码
  # @param [string] :password  密码
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def forget_password
    user = User.active.where(phone: params[:phone]).first
    if user && params[:message_code] && params[:message_code] == Rails.cache.read(params["phone"])
      user.password_digest = params[:password]
      if user.save
        render json: {status: 200, msg: "修改成功", data: {}}
      else
        render json: {status: 200, msg: "修改失败", error_detail: user.errors.messages, data: {}}
      end
    else
      render json: {status: 500, msg: "用户不存在", data:{}}
    end
  end

  #用户设置支付密码
  # POST /users/set_pay_password
  # @param [string] :pay_password  旧密码
  # @param [string] :new_pay_password  新密码
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def set_pay_password
    if !@current_user.pay_password.blank?
      if @current_user.verify_pay_password(params[:pay_password])
        @current_user.pay_password = params[:new_pay_password]
        if @current_user.save
          render json: {status: 200, msg: "修改密码成功", data:{}}
        else
          render json: {status: 500, msg: "修改失败", error_detail: @current_user.errors.messages, data:{}}
        end
      else
        render json: {status: 500, msg: "原支付密码错误", error_detail: @current_user.errors.messages, data:{}}
      end
    else
      @current_user.pay_password = params[:new_pay_password]
      if @current_user.save
        render json: {status: 200, msg: "修改密码成功", data:{}}
      else
        render json: {status: 500, msg: "修改失败", error_detail: @current_user.errors.messages, data:{}}
      end
    end
  end


  #用户忘记支付密码接口
  # @note
  # POST /users/forget_pay_password
  # @param [string] :message_code  验证码
  # @param [string] :pay_password  密码
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def forget_pay_password
    if params[:message_code] && params[:message_code] == Rails.cache.read(phone)
      @current_user.pay_password = params[:pay_password]
      if @current_user.save
        render json: {status: 200, msg: "修改密码成功", data:{}}
      else
        render json: {status: 500, msg: "修改失败", error_detail: @current_user.errors.messages, data:{}}
      end
    else
      render json: {status: 500, msg: "验证码错误或验证码为空",data:{}}
    end
  end



  #用户修改手机号码接口
  # POST /users/reset_phone
  # @param [string] :phone  旧手机号
  # @param [string] :new_phone  新手机号
  # @param [string] :message_code  验证码
  # @param [string] :password  密码
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def reset_phone
    if params[:phone] && params[:phone] == @current_user.phone && [:message_code] && params[:message_code] == Rails.cache.read(phone) && @current_user.verify_password(params[:password])
      @current_user.phone = params[:new_phone]
      if @current_user.save
        render json: {status: 200, msg: "修改手机号成功", data: {}}
      else
        render json: {status: 500, msg: "修改失败", error_detail: @current_user.errors.messages, data: {}}
      end
    else
      render json: {status: 500, msg: "验证码错误或验证码为空或密码不对", data:{}}
    end
  end

  # 绑定手机号码接口
  # POST /users/bind_phone
  # @param [string] :phone  手机号
  # @param [string] :message_code  验证码
  # @param [string] :openid  微信openid, 登陆返回接口中获得
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def bind_phone
    if params[:phone] && params[:message_code] && params[:message_code] == Rails.cache.read(phone)
      wechat_account = WechatAccount.find_by(openid: params[:openid])
      current_user = User.find_by(phone: params[:phone])
      current_user = User.create(phone: params[:phone], nickname: wechat_account.nickname, remote_headimgurl_url: wechat_account.headimgurl, is_agree: true, sex: wechat_account.sex) unless current_user
      if current_user
        wechat_account.update(user_id: current_user.id)
        render json: {status: 200, msg: "绑定成功", data: {user: current_user}}
      else
        render json: {status: 500, msg: "绑定失败", error_detail: current_user.errors.messages, data: {}}
      end
    else
      render json: {status: 500, msg: "绑定失败", data:{}}
    end
  end

  #更新用户基本信息
  # PATCH/PUT /users/1
  # @param [Hash] user 更新
  # @note  /areas.json(获取地区接口)
  # @param [file] user[headimgurl]  头像
  # @param [string] user[area]   地区 北京-北京-北京
  # @param [string] user[nickname]  昵称
  # @param [integer] user[sex] 性别 0 未知 1男 2女
  # @param [datetime]  user[birthday] 生日
  # @param [string]  user[desc] 个人简介
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def update
    if @current_user.update(user_params)
      render json: {status: 200, msg: "修改成功", data: {}}
    else
      render json: {status: 500, msg: "修改失败", error_detail: @current_user.errors.messages, data: {}}
    end
  end



  #用户验证邮箱接口
  # @note
  # POST /users/reset_email
  # @param [string] :email  邮箱
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def reset_email
    @current_user.email = params[:email]
    if @current_user.save
      render json: {status: 200, msg: "修改邮箱成功", data: {}}
    else
      render json: {status: 500, msg: "修改邮箱失败", error_detail: @current_user.errors.messages, data:{}}
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nickname, :headimgurl, :sex, :birthday, :desc, :area)
    end
end
