class InitUnitJob < ApplicationJob
  queue_as :default

  def perform(unit_id, auction_product_id, sku_name, provider_id, amount, provider_price)
    # Do something later
    auction_sku_id = Auction::Sku.where(product_id: auction_product_id, name: sku_name).first&.id
    Auction::Unit.where(id: unit_id).update_all(auction_product_id: auction_product_id, amount: amount, auction_sku_id: auction_sku_id, sku_name: sku_name, provider_id: provider_id, provider_price: provider_price)
  end
end
