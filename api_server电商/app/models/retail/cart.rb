class Retail::Cart < JavaServerRecord
  # CLIENTS = %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat u_iphone u_ipad u_android]

  def self.carts params
    post("/order-service/retail/carts", params)
  end

  def self.insertCarts params
    post("/order-service/retail/insertCarts", params)
  end

  def self.deleteCarts params
    post("/order-service/retail/deleteCarts", params)
  end



end
