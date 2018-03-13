if @trade.present?
  json.status '200'
  json.msg '订单列表'
  json.data do
    json.id @trade.id
    json.identifier @trade.identifier #订单号
    json.symbol @trade.symbol
    json.volume @trade.volume.to_f / 100 #手数
    json.cmd @trade.cmd #0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop
    json.expiration datetime_format @trade.expiration #挂单过期时间
    json.open_time datetime_format @trade.open_time
    json.price @trade.price.to_f
    json.open_price @trade.open_price.to_f
    json.close_time datetime_format @trade.close_time #平仓时间;时间="1970-01-01 00:00:00"为在仓单，反之则为平仓单
    json.close_price @trade.close_price.to_f #平仓价格
    json.sl @trade.sl.to_f #止损价格
    json.tp @trade.tp.to_f #止盈价格
    json.commission @trade.commission.to_f #订单佣金
    json.commission_agent @trade.commission_agent.to_f #代理佣金
    json.taxes @trade.taxes.to_f #利息
    json.profit @trade.profit.to_f #盈亏金额
    json.margin @trade.margin.to_f #订单保证金
  end
else
  json.status '500'
  json.msg '订单不存在'
  json.data {}
end