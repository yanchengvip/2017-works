module PackagesHelper

  # 中奖类型raido id
  def radio_id(key)
    case key
    when 1
      radio_id = 'static_radio'
    when 2
      radio_id = 'random_radio'
    when 3
      radio_id = 'fix_random_radio'
    else
      radio_id = ''
    end

    return radio_id
  end

  def shelf_status(package)
    case package.status
    when -1
      res = '已下架'
    when 0
      res = '未上架'
    when 1
      res = '已上架'
    else
      res = ''
    end
    return res
  end

  def sale_channels_txt(channels)
    case channels
    when '1'
      res = '卡牌商城'
    when '2'
      res = '战场'
    when '3'
      res = '战役兑换'
    when '1,2'
      res = '卡牌商城，战场'
    else
      res =''
    end
    return res
  end

  def prize_type_str(type)
    case type
    when 1
      res = '固定礼包'
    when 2
      res = '随机礼包'
    when 3
      res = '等值随机'
    else
      res =''
    end
    return res
  end

  # 礼包内容对应的奖品范围
  def package_range_str(item)
    res = ''
    card_ids = item&.prize_range&.split(',')
    if card_ids.present?
      res = Card.where(id: card_ids).map(&:name).join(',')
    end

    return res
  end

  # 中奖范围随机
  def prize_range_str(val)
    res = ''
    if val.present?
      res = Card.where(id: val.split(',')).map(&:name).join(',')
    end

    return res
  end

  # 方案价值总和
  def sheme_card_count(package_item, card_id)
    card_index = package_item.prize_range.split(',').index(card_id.to_s)
    count = package_item.range_count.split(',')[card_index]

    return count
  end

  def package_item_type_str(type)
    case type
    when 1
      res = '功勋'
    when 2
      res = '史诗卡牌'
    when 3
      res = '能量'
    when 4
      res = '普通卡牌'
    else
      res = ''
    end

    return res
  end

  def package_item_range_str item
    res = ''
    if item.prize_type.to_i == 1
      res = '功勋'
    elsif item.prize_type.to_i == 3
      res = '能量'
    elsif item.prize_type.to_i.in?([2, 4]) && (card = Card.active.find_by(id: item.prize_range.to_i))
      res = card.name
    end

    return res
  end

  def key_percent game_rule
    res = game_rule.open_user_num == 0 ? 0 : (100.0/game_rule.open_user_num).round(2)
    return res
  end

  def game_status game
    res = ''
    case game.status
    when 0
      res = '下架'
    when 2
      res = '待开局'
    when 3
      res = '开局中'
    when 4
      res = '已开奖'
    when 5
      res = '修整中'
    when 6
      res = '开奖中'
    when 9
      res = '战役非正常结束'
    end

    return res
  end

  # 赛场类型状态
  def game_type_status status
    res = ''
    case status
    when 0
      res = '未启用'
    when 1
      res = '启用'
    when -1
      res = '停用'
    end

    return res
  end

end
