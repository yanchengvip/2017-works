module BattleProductsHelper

  def battle_bproduct_status status
    case status.to_i
      when 1
        flag = '未上架'
      when 2
        flag = '已上架'
      when 3
        flag = '已下架'
    end
    return flag
  end

  def product_channel product
    res = []
    if product.is_game_product
      res << '赛场商品'
    end
    if product.is_self_game_product
      res << '自建赛场商品'
    end
    if product.is_mall_product
      res << '兑奖阁商品'
    end

    return res.join('/')

  end

  def tag_select product_tag_id, tag_id
    return res = product_tag_id == tag_id ? 'selected' : nil
  end

  def tags_select product_tag_ids, tag_id
    ids = product_tag_ids&.split(',')&.map(&:to_i)
    return res = ids&.include?(tag_id) ? 'selected' : nil
  end

  def mall_product_tag_name ids
    ids = ids&.split(',')&.map(&:to_i)
    res = MallProductTag.active.where(id: ids)&.pluck(:name)&.join(',')
    return res
  end

  def phone_fee_selected battle_product, fee
    s = ''
    unless battle_product.blank?
      if battle_product.product_type == 1 && battle_product.product_num == fee
        s = 'selected'
      end
    end
    return s
  end

  def product_type_checked(battle_product, num)
    s = nil
    unless battle_product.blank?
      s = 'checked' if battle_product.product_type == num
    end
    return s
  end

end
