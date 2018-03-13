class Api::ChestRecordsController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:alipay_notify]

  def jd_info
    if current_user.card_user_third_parties.where(type: 0).blank?
      render json: {
          "execResult" => false,
          "execMsg" => "请绑定微信",
          "execData" => {}, "execDatas" => [], "execErrCode" => "1707"}
    else
      chest_record = current_user.chest_records.where(id: params[:id]).first
      if chest_record && chest_record.jd_card
        render json: {
          "execResult" => true,
          "execMsg" => "成功",
          "execData" => {
              "jd_card" => chest_record.jd_card
          },
          "execDatas" => [],
          "execErrCode" => "200"
        }
      else
        render json: {
          "execResult" => false,
          "execMsg" => "京东卡未发放或奖品中不存在京东卡",
          "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
      end
    end
  end

  def index
    chest_records = ChestRecord.get_list(current_user, params[:type].to_i, params)
    render json: {
        "execResult" => true,
        "execMsg" => "成功",
        "execData" => {
            "chest_records" => chest_records
        }, "execDatas" => [], "execErrCode" => "200"}
  end


  def awards
    awards_count = ChestRecord.where(user_id: @current_user["id"], status: [0, 1]).count
    unclaimed_count = ChestRecord.where(user_id: @current_user["id"], status: 0).count #未领取奖品的数量
    render json: {
        "execResult" => true,
        "execMsg" => "成功",
        "execData" => {
            "awards_count" => awards_count,
            "unclaimed_count" => unclaimed_count
        },
        "execDatas" => [],
        "execErrCode" => "200"
    }
  end


  def pay_amount
    chest_record = ChestRecord.where(id: params[:id], user_id: current_user.id).first
    chest_prize = ChestPrize.where(id: chest_record.chest_prize_ids.split(','), prize_type: 1) #需要支付的商品
    total_amount = chest_prize.sum(:postage) #支付金额
    prize_names = chest_prize.pluck(:name).join(',')
    render json: {execResult: true, execMsg: '支付金额', execErrCode: 200, execDatas: {prize_names: prize_names, total_amount: total_amount}}
  end

  #到付
  def express
    begin
      chest_record = ChestRecord.where(id: params[:id], user_id: current_user.id).first
      if chest_record
        chest_prize = ChestPrize.where(id: chest_record.chest_prize_ids.split(','), prize_type: 1) #需要支付的商品
        total_amount = chest_prize.sum(:postage) #支付金额
        if total_amount > 0
          chest_record.update!(ship_status: 4)
          res = {execResult: true, execMsg: '到付选择成功', execErrCode: "200", execData: {}}
        else
          chest_record.update_attributes(ship_status: 4)
          res = {execResult: true, execMsg: '此奖品不需要支付运费，等待发货', execErrCode: "200", execDatas: {}}
        end
      else
        res = {execResult: true, execMsg: '不存在待支付订单', execErrCode: "500", execDatas: {}}
      end
    rescue Exception => e
      res = {execResult: true, execMsg: '订单状态异常', execErrCode: "500", execDatas: {error: e.as_json}}
    end
    render json: res
  end

  #支付宝支付
  def alipay
    begin
      chest_record = ChestRecord.where(id: params[:id], user_id: current_user.id).first
      if chest_record
        out_trade_no = chest_record.code
        chest_prize = ChestPrize.where(id: chest_record.chest_prize_ids.split(','), prize_type: 1) #需要支付的商品
        prize_names = chest_prize.pluck(:name).join(',')
        total_amount = chest_prize.sum(:postage) #支付金额
        if total_amount > 0
          pay_params ={
              return_url: params[:return_url],
              notify_url: ALIPAYCONFIG[:alipay][:host] + 'api/chest_records/alipay_notify',
              biz_content: {subject: prize_names, out_trade_no: out_trade_no, total_amount: total_amount}
          }
          url = MyAlipay::Wap::Service.create_alipay_trade_wap_pay_url pay_params
          Rails.logger.info(url)
          res = {execResult: true, execMsg: '支付成功', execErrCode: 200, execDatas: {url: url, postage: total_amount}}
        else
          chest_record.update_attributes(ship_status: 3)
          res = {execResult: true, execMsg: '此奖品不需要支付运费，等待发货', execErrCode: 201, execDatas: {postage: total_amount}}
        end
      end
    rescue Exception => e
      res = {execResult: true, execMsg: '支付失败', execErrCode: 400, execDatas: {error: e.as_json}}
    end
    #redirect_to url
    render json: res
  end


  #支付宝支付回调验签
  def alipay_notify
    flag = 'false'
    is_verify = MyAlipay::Notify.verify? params.as_json
    chest_record = ChestRecord.where(code: params[:out_trade_no]).first
    if is_verify
      p1 = {'user_id': chest_record&.user_id,
            'out_trade_no': chest_record&.id,
            'pay_type': 1,
            'trade_no': params[:trade_no],
            'notify_id': params[:notify_id],
            'notify_time': params[:notify_time],
            'gmt_payment': params[:gmt_payment],
            'buyer_id': params[:buyer_id],
            'seller_id': params[:seller_id],
            'total_amount': params[:total_amount],
            'receipt_amount': params[:receipt_amount],
            'buyer_pay_amount': params[:buyer_pay_amount],
            'content': params.as_json
      }
      ChestRecordPay.create(p1)
      chest_record.update_attributes(ship_status: 3) if chest_record
      flag = 'success'
    end
    render json: flag
  end

end
