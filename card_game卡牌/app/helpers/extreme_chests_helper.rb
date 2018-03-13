module ExtremeChestsHelper

  def status_str(val)
    res = val ? '启用' : '禁用'

    return res
  end

  # 赠品范围名称
  def extreme_chest_item_gift_range_str(item)
    res = ''
    if item.gift_type == 1
      res = Card.find_by(id: item.gift_range.to_i).name
    elsif item.gift_type == 2
      res = '入场券'
    elsif item.gift_type == 3
      res = '能量'
    end
    return res
  end

  # 注册赠送赠品范围名称
  def gift_item_gift_range_str(item)
    res = ''
    if item.gift_type == 1
      res = Card.find_by(id: item.gift_range.to_i).name
    elsif item.gift_type == 2
      res = '入场券'
    elsif item.gift_type == 3
      res = '能量'
    end
    return res
  end
end
