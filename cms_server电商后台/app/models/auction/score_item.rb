class Auction::ScoreItem < ApplicationRecord
  belongs_to :table, polymorphic: true
  belongs_to :user
  # attr_accessible :amount, :out_trade_no, :status, :table_id, :table_type, :drp_server_trade_no

  after_create :notify_drp_service

    #通知微积分服务增加用户积分
  def notify_drp_service
    params = {account: self.user.account.phone || self.user.account.email, channel: 1, amount: self.amount, timestamp: Time.now.strftime("%Y%m%d%H%M%S%L"), out_trade_no: self.out_trade_no}
    # 行为：1:兑换能量 2：购买优惠卷 3：购买商品 4：退货 5：过期清除',
    params[:type] =  self.table_type == "Auction::VoucherTrade" ? 2 :  (self.amount >= 0 ? 3 : 4)
    url = Setting["drp_service"]["host"]+"/drp-service-web/recharge/rechargeService"
    params[:sign] = Digest::MD5.hexdigest("account=#{params[:account]}&channel=1&amount=#{params[:amount]}").upcase
    rsa_string = Auction::ScoreItem.rsa_sign(params.to_json).gsub("\n", "")
    res = false
    self.with_lock do
      if self.status == 0
        response = JSON.parse(Timeout::timeout(30){ Faraday.new.post(url, {param: rsa_string}).body })
        p response
        if response["execResult"] == true && response["execData"] && response["execData"]["tradeNo"]
          self.drp_server_trade_no = response["execData"]["tradeNo"]
          self.status = 1
          self.save!
          res = true
        end
      end
    end
    return res
  end

  #微积分服务签名
  def self.rsa_sign(rsa_string)

    pri = OpenSSL::PKey::RSA.new(Base64.decode64(Setting["drp_service"]["rsa_private_key"]))
    sign = ""
    index = 0
    res = []
    size = 117
    while(index < rsa_string.size)
      res << (rsa_string[index, size])
      index += size
    end
    res.each {|str| p str; sign += pri.private_encrypt(str)}
    signature = Base64.encode64(sign)
    return signature
  end

end
