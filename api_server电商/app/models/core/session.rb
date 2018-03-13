class Core::Session < JavaServerRecord
  def self.login params
    post("/user-service/login", params)
  end
  def self.logout params
    post("/user-service/core/sessions",params)
  end
end
