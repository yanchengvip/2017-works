module TaskSettingsHelper
  # 赠品类型
  def task_item_type_str(type)
    case type
    when 1
      res = '功勋'
    when 2
      res = '卡牌'
    when 3
      res = '能量'
    else
      res = ''
    end

    return res
  end

  def task_item_range_str item
    res = ''
    if item.prize_type == 1
      res = '功勋'
    elsif item.prize_type == 3
      res = '能量'
    elsif item.prize_type == 2 && (card = Card.active.find_by(id: item.card_id))
      res = card.name
    end

    return res
  end

  # 完成条件
  def need_str task_setting
    if task_setting.task_type.in?([1, 4, 5])
      res = TaskSetting::TASK_TYPE[task_setting.task_type]
    elsif task_setting.task_type == 2
      res = "每日参战<strong class='red ml_5 mr_10'>#{task_setting.need_count}</strong>次"
    elsif task_setting.task_type == 3
      res = "每日战场首次出击<strong class='red ml_5 mr_10'>#{task_setting.need_count}</strong>次"
    end

    return res
  end

  # 次数限制
  def reward_times_str task_setting
    res = "#{task_setting.reward_times}次"
    # case num
    # when -1
    #   res = '不限次数'
    # when 0
    #   res = '每日一次'
    # end

    if task_setting.task_type != 6
      res = '不限次数' if task_setting.reward_times == -1
      res = '不限次数' if task_setting.reward_times == 0
    else
      res = "胜利获得#{task_setting.from_win_num}次，失败获得#{task_setting.from_fail_num}次"
    end

    return res
  end

  def table_link operate_log
    eval("#{operate_log.table_type.downcase}_path(#{operate_log.table_id})")
  end

  def unlock_cont head_frame
    res = ''
    if head_frame.unlock_condition == -2
      res = '注册赠送'
    elsif head_frame.unlock_condition == -1
      res = '能量兑换'
    elsif head_frame.unlock_condition >=0
      res = "饕餮#{head_frame.unlock_level}级"
    end

    return res
  end

  def select_level head_frame
    if head_frame.unlock_condition == 0
      return head_frame.unlock_level
    else
      return head_frame.unlock_condition
    end
  end

  def show_thumb obj, resize = true
    if resize
      image_tag  FASTDFSCONFIG[:fastdfs][:tracker_url] + (obj.thumbnail || ''), width: 60, height: 60 if obj.thumbnail
    else
      image_tag  FASTDFSCONFIG[:fastdfs][:tracker_url] + (obj.thumbnail || '') if obj.thumbnail
    end
  end

  def is_always head_frame
    head_frame.use_limit == 0 ? true : nil
  end

  def not_always head_frame
    head_frame.use_limit > 0 ? true : nil
  end


end
