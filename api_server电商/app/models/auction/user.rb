class Auction::User < JavaServerRecord
  def self.users params
    post("/user-service/core/users/", params)
  end
  def self.updateuser params
    post("/user-service/auction/users/", params)
  end
end
