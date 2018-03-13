json.execResult true
json.execMsg '提现记录'
json.execErrCode 200
json.execDatas do
  json.array! @orders do |b|
    json.id b.id
    json.amount b.amount.to_f
    json.status b.status #提现状态
    json.create_time b.created_at.present? ? b.created_at.strftime("%Y-%m-%d %H:%M") : ''
  end
end