class Auction::Category < JavaServerRecord
  def self.list params
    post("/shop-service/category/listCategories", params)
  end
end
