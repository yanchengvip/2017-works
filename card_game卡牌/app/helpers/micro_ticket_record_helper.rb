module MicroTicketRecordHelper

  def micro_ticket_record_change_type change_type
    case change_type.to_i
    when 1
      "获取"
    when 2
      "消费"
    else
      change_type
    end
  end

  def micro_ticket_record_channel channel
    case channel.to_i
    when 1
      1
    #   "获取"
    # when 2
    #   "消费"
    else
      channel
    end
  end
end
