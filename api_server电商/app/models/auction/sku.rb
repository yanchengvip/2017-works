class Auction::Sku < Base
  def self.options params
    post("auction/skus/options", params)
  end
end
