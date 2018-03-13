module ApplicationHelper

  def datetime_format datetime
    if datetime.present?
      return datetime.strftime('%Y-%m-%d %H:%M:%S')
    end
    return '无'
  end
end
