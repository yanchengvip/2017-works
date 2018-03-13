class Auction::Contact < JavaServerRecord
  def self.get_contry params
    post("/user-service/auction/countriesPros", params)
  end
  def self.listCarts params
    post("/user-service/auction/listCarts",params)
  end
  def self.insertContacts params
    post("/user-service/auction/insertContacts",params)
  end
  def self.updateContacts params
    post("/user-service/auction/updateContacts",params)
  end
  def self.deleteContacts params
    post("/user-service/auction/deleteContacts",params)
  end
  def self.getContacts params
    post("/user-service/auction/getContacts/0", params)
  end
  def self.setDefaultContact params
    post("/user-service/auction/setDefaultContact",params)
  end
  def self.defaultContact params
    post("/user-service/auction/defaultContact",params)
  end
end
