module Auction::PromotionActivityApplyProductsHelper
  #优众价
  def auction_excellent_price(price,rate_of_margin,
    discount_type,multiple_sales_discount,
    price_more,price_off,pre_price_off,
    pre_price_more,pre_discount_total,
    partner_type,invoice_type)
    activity_bonus = ""
    outstanding = ""
    if partner_type == 1
      activity_bonus = rate_of_margin / (1 - rate_of_margin)
    else
      activity_bonus = (rate_of_margin + 0.17 + rate_of_margin * invoice_type - invoice_type) / ( 1- rate_of_margin) / (1 + invoice_type)
    end
    if discount_type == 1
      activity_price = price * (1 + activity_bonus)
      outstanding = activity_price / multiple_sales_discount
    elsif discount_type == 2
      activity_price = price * (1 + activity_bonus)
      if pre_discount_total.blank?
        outstanding = activity_price * pre_price_more / (pre_price_more - pre_price_off)
      else
        outstanding1 = activity_price * pre_price_more / (pre_price_more - pre_price_off)
        outstanding2 = activity_price + pre_discount_total
        outstanding = outstanding1 < outstanding2 ? outstanding1 : outstanding2
      end
    elsif discount_type == 3
      activity_price = price * (1 + activity_bonus)
      if activity_price < price_more
        outstanding = activity_price + activity_price * price_off /  price_more
      else
        outstanding = activity_price + price_off
      end
    end
    return outstanding.to_i
  end
  #活动价
  def auction_activity_price(rate_of_margin,partner_type,invoice_type,price)
    activity_bonus = ""
    if partner_type == 1
      activity_bonus = rate_of_margin / (1 - rate_of_margin)
    else
      activity_bonus = (rate_of_margin + 0.17 + rate_of_margin * invoice_type - invoice_type) / ( 1- rate_of_margin) / (1 + invoice_type)
    end
    activit_money = price / (1 + activity_bonus)
    activit_money = activit_money.to_i
  end
  #降价幅度
  def excellent_down_price(price,rate_of_margin,discount_type,
    multiple_sales_discount,price_more,price_off,
    pre_price_off,pre_price_more,pre_discount_total,partner_type,invoice_type,ot_price)
    activity_bonus = ""
    outstanding = ""
    if partner_type == 1
      activity_bonus = rate_of_margin / (1 - rate_of_margin)
    else
      activity_bonus = (rate_of_margin + 0.17 + rate_of_margin * invoice_type - invoice_type) / ( 1- rate_of_margin) / (1 + invoice_type)
    end
    if discount_type == 1
      activity_price = price * (1 + activity_bonus)
      outstanding = activity_price / multiple_sales_discount
    elsif discount_type == 2
      activity_price = price * (1 + activity_bonus)
      if pre_discount_total.blank?
        outstanding = activity_price * pre_price_more / (pre_price_more - pre_price_off)
      else
        outstanding1 = activity_price * pre_price_more / (pre_price_more - pre_price_off)
        outstanding2 = activity_price + pre_discount_total
        outstanding = outstanding1 < outstanding2 ? outstanding1 : outstanding2
      end
    elsif discount_type == 3
      activity_price = price * (1 + activity_bonus)
      if activity_price < price_more
        outstanding = activity_price + activity_price * price_off /  price_more
      else
        outstanding = activity_price + price_off
      end
    end
    return ot_price - outstanding.to_i
  end

end
