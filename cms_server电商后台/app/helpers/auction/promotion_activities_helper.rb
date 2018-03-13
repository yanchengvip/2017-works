module Auction::PromotionActivitiesHelper
  def promotion_popover_placement index
    if index >= 15
      return 'top'
    end
    return 'bottom'
  end


  def merchants_status promotion
    #招商结束时间 和当前时间做对比 >当前时间    <当前时间
    text = ""
    if promotion.status.in? [0,1,5,6]
      text = "未开始"
    elsif promotion.status == 3
      if promotion.declar_end > Time.now && promotion.declar_begin < Time.now
        text = "招商中"
      elsif promotion.declar_end < Time.now
        text = "招商结束"
      elsif promotion.declar_begin > Time.now
        text = "未开始"
      end
    elsif promotion.status == 4
      text = "招商结束"
    end

  end

end
