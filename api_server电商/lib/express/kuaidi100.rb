module Kuaidi100
  Key = "NECqxUrS2626"
  Customer = "157E92B1594C114CA2377A627EC0892F"
  #com 快递公司编码
  #num 快递单号
  def self.query_express(com, num)
    params = {com: com, num: num, from: "", to: ""}.to_json
    body = {customer: Customer, param: params, sign: Digest::MD5.hexdigest(params + Key + Customer).upcase}
    conn = Faraday.new
    JSON.parse conn.post("http://poll.kuaidi100.com/poll/query.do", body).body
  end
end
