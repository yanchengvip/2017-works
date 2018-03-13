module MsgRecordsHelper

  def msg_type_str(val)
    case val.to_i
    when 1
      res = '推送消息'
    when 2
      res = '公告'
    when 3
      res = '活动消息'
    end
  end
end
