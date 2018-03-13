module CardsHelper

  def card_type_str(type)
    case type
    when 1
      res = '进攻类'
    when 2
      res = '防御类'
    when 3
      res = '效果类'
    else
      res = ''
    end

    return res
  end

  # 卡牌属性
  def card_attrs(card)
    return CARDCONFIG[card.code.to_i]['cols']
  end

  # 目标范围
  def aim_range_str(val)
    case val
    when 1
      res = '单体'
    when 2
      res = '全体'
    else
      res = ''
    end

    return res
  end

  # 扣减对象
  def attach_aim_str(val)
    case val
    when 1
      res = '自己'
    when 2
      res = '对方'
    when 3
      res = '随机他人'
    else
      res = ''
    end

    return res
  end

  # 转移类型
  def transfer_type_str(val)
    case val
    when 0
      res = '无'
    when 1
      res = '转移密钥'
    when 2
      res = '转移计谋'
    when 3
      res = '优先获取计谋，没有计谋获取密匙'
    when 4
      res = '比较密匙大小，大的一方获取小的一方一定比例密匙'
    when 5
      res = '受到攻击，进攻方需补充1倍相同卡牌才可生效，否则攻击无效，有效1次（对连环计无效）'
    when 6
      res = '使对手随机损失多张卡牌（损失）数量与本回合消耗倍数有关'
    else
      res = ''
    end

    return res
  end

  # 生效计谋
  def effect_condition_str(card)
    arr = card.effect_condition.split(',')
    res = Card.where(code: arr).map(&:name).join('，')

    return res
  end

  # def imgurl_fix imgurl
  #   return '' if imgurl.blank?
  #   res = imgurl[1, imgurl.length] if imgurl[0] == '/' && Rails.env.production?
  #   return res.blank? ? imgurl : res
  # end

  def imgurl_fix imgurl
    res = imgurl[1, imgurl.length] if imgurl[0,2] == '//'
    return res.blank? ? imgurl : res
  end

end
