class Api::SmsMessageController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:send_sms]
  def send_sms
    code = "%06d" % rand(999999)
    Rails.cache.write("mobile_code:#{params[:mobile]}", code)
    CardSms.send_message(params[:mobile], "验证码为：#{code}")
    render json: {"execResult"=>true, "execMsg"=>"发送成功", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"200"}
  end
end
