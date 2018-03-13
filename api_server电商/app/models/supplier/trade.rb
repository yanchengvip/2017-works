class Supplier::Trade < ApplicationRecord

  def self.receive params
    post("/auction/trades/receive", params)
  end

end
