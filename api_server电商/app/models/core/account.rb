class Core::Account < JavaServerRecord
  def self.insert params
    post("/user-service/core/accounts", params)
  end
  def self.updateaccount params
    post("/user-service/update/accounts", params)
  end
  def self.forgetPassword params
    post("/user-service/core/accounts/forgetPassword",params)
  end

  def self.token params
    post("/user-service/token", params)
  end

  def self.get_by_id params
    post("/user-service/accounts/byid", params)
  end



end
