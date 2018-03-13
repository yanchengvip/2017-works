json.execResult true
json.execMsg '奖金明细'
json.execErrCode 200
json.execDatas do
    json.array! @balance_details do |b|
      json.id b.id
      json.amount b.fund.to_f
      json.trad_type AccountTicketBalanceDetail::TRADTYPE[b.trad_type]
      json.level b.level
      json.create_time b.created_at.present? ? b.created_at.strftime("%Y-%m-%d %H:%M") : ''
    end
end