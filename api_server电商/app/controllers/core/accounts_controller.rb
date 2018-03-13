class Core::AccountsController < ApplicationController

  # 发送验证码
  # params[:account] phone
  def resend_activation_code
    if verify_rucaptcha? && params[:phone] && params[:phone].match(/^1\d{10}$/)
      code = "%06d" % rand(999999)
      if Auction::Sm.create(phone: params[:phone],content: "短信验证码" + code)
        Rails.cache.write(phone = params[:phone], code, expire_time: 5 * 60)
        render json: {status: 200, msg: "验证码已发送", data:{}}
      else
        render json: {status: 500, msg: "验证码发送频次过快，请稍后重试", data: {}}
      end
    else
      render json: {status: 500, msg: "验证码错误或手机号不正确", data: {}}
    end

    # @account.make_phone_activation_code
    # @account.save
    # @account.send_active_sms
    #
    # respond_to do |format|
    #   format.json { render json:{status: 200, msg: 'success', data:{}} }
    # end
  end

  # POST /core/accounts
  # POST /core/accounts.json
  # \account[phone] :: 手机 *
  # \account[password] :: 密码
  # \account[password_confirmation] :: 确认密码
  # \user[name] :: 姓名
  # \user[sex] :: 性别
  # \user[birthday] :: 生日
  # \account[client] :: 客户端类型, 必须为 %w[iphone android wechat pc touch] 之一
  # _rucaptcha :: 验证码 必填
  def create
    if !params[:message_code].blank? && !params[:account][:client].blank? && !params[:account][:phone].blank? && !params[:account][:password].blank? && params[:account][:password] == params[:account][:password_confirmation] && params[:message_code] == Rails.cache.read(params[:account][:phone])
      core_account = Core::Account.insert params
      if core_account[:comm][:code] == "200"
        render json: {status: core_account[:comm][:code].to_i, msg: core_account[:comm][:msg], data: {core_account: core_account[:data][:core_account]}}
      else
        render json: {status: core_account[:comm][:code].to_i, msg: core_account[:comm][:msg], data: {}}
      end

    else
      render json: {status: 500, msg: "短信验证码错误或参数请求不能为空", data: {}}
    end

  end


  #更新用户基本信息修改手机号、密码、 邮箱、
  # PATCH/PUT /core/accounts/1
  # @param [Hash] core_account 更新
  # @param [string] account[phone]  电话
  # @param [string] account[crypted_password]   密码
  # @param [string] account[email]  邮箱
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def update
    params[:account].merge!(id: params[:id])
    core_account = Core::Account.updateaccount params
    render json: {status: core_account[:comm][:code].to_i, msg: core_account[:comm][:msg], data: {}}
  end
  #用户忘记密码修改密码接口
  # POST /core/accounts/forget_password
  # @param [string] :phone  手机号
  # @param [string] :message_code  验证码
  # @param [string] :password  密码
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def forget_password
    if !params[:account][:phone].blank? && !params[:account][:password].blank? && params[:account][:password] == params[:account][:password_confirmation] && params[:message_code] == Rails.cache.read(params[:account][:phone])
      core_account = Core::Account.forgetPassword params
      render json: {status: core_account[:comm][:code].to_i, msg: core_account[:comm][:msg], data: {}}
    else
      render json: {status: 500, msg: "参数不能为空或两次密码不一致或验证码错误", data: {}}
    end
  end

end
