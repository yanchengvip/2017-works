class InitCartJob < ApplicationJob
  queue_as :default

  def perform(cart_id, product_id, measure, sku_id)
    # Do something late
    # cart = Retail::Cart.find(cart_id)
    # sku = Auction::Sku.where(product_id: product_id, active: true, name: measure).first
    Retail::Cart.where(id: cart_id).update_all(sku_id: sku_id)
  end
end
