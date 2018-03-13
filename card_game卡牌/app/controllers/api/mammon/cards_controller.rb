class Api::Mammon::CardsController < Api::ApplicationController
  def status

    if period = Mammon::Period.current
      render json: {
        "execResult": true,
        "execMsg": "",
        "execData": period.user_status(current_user),
        "execDatas": [],
        "execErrCode": "200"
      }
    else
      render json: {
        "execResult": true,
        "execMsg": "",
        "execData": {},
        "execDatas": [],
        "execErrCode": "200"
      }
    end
  end

  def use
    begin
      res = Mammon::Card.use(current_user, params[:card_id], params[:user_id])
    rescue Exception => e
      Rails.logger.info("card_use***********")
      Rails.logger.info(e)
      res = {
        "execResult": false,
        "execMsg": "",
        "execData": {error: e.as_json},
        "execDatas": [],
        "execErrCode": "500"
      }
    end
    Rails.logger.info("card_use_res********")
    Rails.logger.info(res)

    render json: res
  end
end
