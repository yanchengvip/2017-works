class MsgRecord < ApplicationRecord

  MSGTYPE = {1 => '推送消息', 2 => '公告', 3 => '活动消息'}

  after_save :deal_is_show

  def self.push_msg(site, exec_method, options = {})
    res = false
    begin
      Timeout.timeout(120) do
        con = RestClient.post("#{site}#{exec_method}", options)
        res = JSON.parse(con.body)['execResult']
      end
    rescue Exception => e
      p '+++++++++++++++++++++++++++++++++++++'
      p e.to_s
      res = false
    end
    return res
  end

  def save_msg!(params)
    if params[:msg_type].to_i == 1
      res = MsgRecord.push_msg(SYSTEMCONFIG['java_redis_url'], "/card-service-web/msg/sendPushMsg", {title: params[:title], content: params[:content]})
    else
      res = self.save
    end

    return res
  end

  def self.apiClient(exec_method, options = {})
    res = {}
    site = options[:site].presence || SYSTEMCONFIG['java_redis_url']

    begin
      Timeout.timeout(120) do
        con = RestClient.post("#{site}#{exec_method}", options.except(:site))
        result = JSON.parse(con.body)
        res.merge!({succ: result['execResult'], msg: result['execMsg'], data: result['execDatas'], code: result['execErrCode']})
        Rails.logger.info('<><><><><<><>><<><><><<<>><<><><<><')
        Rails.logger.info(res)
      end
    rescue Exception => e
      Rails.logger.info('+++++++++++++++++++++++++++++++++++++')
      Rails.logger.info(e.to_s)
      res = res.merge!({succ: false, msg: '接口调用异常', data: [options[:userId]], code: 500})
      Rails.logger.info(res)
      Rails.logger.info('--------------------------------------')
    end

    return res
  end

  private
  def deal_is_show
    if self.is_show && self.msg_type != 1
      msg_records = MsgRecord.active.where(msg_type: self.msg_type, is_show: true).where.not(id: self.id)
      msg_records.update_all(is_show: false)
    end
  end
end
