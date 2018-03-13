class Core::Report < JavaServerRecord
  def self.insert params
    post("/user-service/reports/insert", params)
  end
end
