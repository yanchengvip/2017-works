class Api::ApplicationController < ActionController::Base
  before_action :authenticate_user
  # skip_before_action :verify_authenticity_token
  def authenticate_user
    if current_user
    else
      render json: {"execResult"=>false, "execMsg"=>"登录失效或未登录，请重新登录", "execData"=>nil, "execDatas"=>[], "execErrCode"=>"4003"}
    end
  end

  def check_binding_mobile
    unless current_user.is_binding_mobile?
      render json: {
          "execResult" => false,
          "execMsg" => "请绑定手机号",
          "execData" => {}, "execDatas" => [], "execErrCode" => "1708"} and return
    end
  end

  def current_user
    @current_user ||= get_current_user
  end

  def get_current_user
    if Rails.env == 'development'
      return User.where(login_name: 18101341113).first
    end
    return nil unless request.headers["accessToken"]

    user_id = Rails.cache.fetch("get_current_user_id_by_token:#{request.headers['accessToken']}", expires_in: 60){
      res = JSON.parse(RestClient.post(SYSTEMCONFIG['java_redis_url'] + "/card-service-web/user/queryUserByAccessToken", {}, {accessToken: request.headers["accessToken"]}))

      if res["execErrCode"].to_i == 200
        res["execData"]["user"]["userId"]
      else
        nil
      end
    }
    if user_id
      return User.find user_id
    else
      nil
    end
  end

  def testlogin
    res =JSON.parse(RestClient.post(SYSTEMCONFIG['java_redis_url'] + "/card-service-web/user/login", {loginName: "18101341113", password: "123123"}).body)
  end
end
