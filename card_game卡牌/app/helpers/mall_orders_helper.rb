module MallOrdersHelper

  def mall_order_checked_status current_status, status
    s = ''
    if current_status.to_i == status.to_i
      s = 'selected'
    end
    return s
  end
end
