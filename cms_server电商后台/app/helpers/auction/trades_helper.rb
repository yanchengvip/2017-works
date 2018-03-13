module Auction::TradesHelper

  def is_show_freezed_button trade
    if trade.payment_service == 'express' && trade.status == 'audit'
      return true
    end
    return false
  end


  def trade_popover_placement index
    if index >= 15
      return 'top'
    end
    return 'bottom'
  end


  def trades_show_tab tab1,tab2
    if tab1.to_i == tab2.to_i
      return 'active'
    end
  end
end
