module Supplier::PromotionActivitySuppliersHelper
  def status_text(status, promotion_begin, promotion_end)
    res = ""
    if status == 3
      if promotion_begin > Time.now
        res = "未开始"
      elsif promotion_end > Time.now && promotion_begin < Time.now
        res = "进行中"
      elsif promotion_end < Time.now
        res = "已结束"
      end
    else
      res = "已结束"
    end

  end

end
