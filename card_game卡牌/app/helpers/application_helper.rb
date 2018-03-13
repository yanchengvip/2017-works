module ApplicationHelper


  def datetime_format datetime
    if datetime.present?
      return datetime.strftime('%Y-%m-%d %H:%M')
    end
    return '无'
  end

  def time_format time
    if time.present?
      return time.strftime('%H:%M')
    end
    return '无'
  end

  def is_selected v1, v2
    if v1 == v2
      return 'selected'
    end
  end

end
