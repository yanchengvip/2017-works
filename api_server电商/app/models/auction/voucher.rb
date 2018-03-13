class Auction::Voucher < JavaServerRecord
  def self.vouchers params
    post("/user-service/auction/vouchers",params)
  end
  def self.updatevouchers params
    post("/user-service/exchange/vouchers",params)
  end
end
