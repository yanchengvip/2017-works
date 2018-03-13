class Auction::Favorite < JavaServerRecord
  def self.delete params
    post("/user-service/favorites/delete", params)
  end
  def self.list params
    post("/user-service/favorites/list", params)
  end
  def self.insert params
    post("/user-service/favorites/insert", params)
  end
  def self.isProductCollect params
    post("/user-service/favorites/isProductCollect", params)
  end
end
