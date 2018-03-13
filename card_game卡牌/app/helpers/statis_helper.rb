module StatisHelper
  def wealth_type_txt(type)
    res = '未知'
    case type.to_i
    when 1
      res = '减少'
    when 2
      res = '增加'
    end

    return res
  end

  def trad_type_txt(type)
    res = '未知'
    case type.to_i
    when 1
      res = '购买'
    when 2
      res = '赠送'
    when 3
      res = '消费'
    when 4
      res = '分享领取'
    when 5
      res = '宝箱领取'
    when 6
      res = '任务领取'
    when 7
      res = '后台赠送'
    end

    return res
  end

  def change_type_txt(type)
    res = '未知'
    case type.to_i
    when 1
      res = '增加'
    when 2
      res = '减少'
    end

    return res
  end

  def al_type_txt(type)
    res = '未知'
    case type.to_i
    when 1
      res = '兑换能量'
    when 2
      res = '购买优惠卷'
    when 3
      res = '购买商品'
    when 4
      res = '退货'
    when 5
      res = '过期清除'
    when 6
      res = '补差价'
    when 7
      res = '兑换商品'
    end

    return res
  end

  def atd_type_txt(type)
    res = '未知'
    case type.to_i
    when 1
      res = '微集卷'
    when 2
      res = '能量'
    end

    return res
  end

end
