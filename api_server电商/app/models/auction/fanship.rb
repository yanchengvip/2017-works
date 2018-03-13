class Auction::Fanship < JavaServerRecord
  def self.delete params
    post("/user-service/fanships/delete", params)
  end
  def self.list params
    post("/user-service/fanships/list", params)
  end
  def self.insert params
    post("/user-service/fanships/insert", params)
  end
  def self.isBrandCollect params
    post("/user-service/fanships/isBrandCollect", params)
  end
end
