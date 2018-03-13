json.status '200'
json.msg '成功'
json.data do
  if @payment_service != 'express'
    #货到付款
    json.payment_service 'express' #付款方式
    json.return_name '退款人'
    json.return_phone '退款电话'
    json.return_province '退款省份'
    json.return_city '退款城市'
    json.return_branch '开会行支行'
    json.return_account '银行账号'
  else
    #在线支付
    json.payment_service 'alipay' #付款方式
    json.return_phone '15810159363'
  end

end



