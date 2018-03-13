class Api::Mammon::UserCodesController < Api::ApplicationController

  def index
    if period = Mammon::Period.current
      user_codes = Mammon::UserCode.includes(:attack_user).where(period_id: period.id, user_id: current_user.id).where("count > 0").order(created_at: :desc).ransack(params[:q]).result.page(params[:page]).per(15).as_json(Mammon::UserCode.xml_options)
      render json: {
          execResult: true,
          execMsg: "",
          execErrCode: 200,
          execData: {user_codes: user_codes}
      }
    else
      render json: {
          execResult: true,
          execMsg: '财神活动未开启',
          execErrCode: 500,
          execData: {}
      }
    end
  end

  #我的号码
  def my_codes
    begin
      codes_array = Mammon::Period.find(params[:period_id]).user_codes current_user
      render json: {
          execResult: true,
          execMsg: '我的号码',
          execErrCode: 200,
          execData: {codes: codes_array}
      }
    rescue Exception => e
      render json: {
          execResult: true,
          execMsg: '网络异常，稍后重试',
          execErrCode: 400,
          execData: {error: e.as_json}
      }
    end

  end



  private

  def set_mammon_user_code
    @mammon_user_code = Mammon::UserCode.find(params[:id])
  end

end
