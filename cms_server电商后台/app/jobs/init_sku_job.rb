class InitSkuJob < ApplicationJob
  queue_as :default

  def perform(sku)
    Auction::Sku.create(sku)
    # Do something later
  end
end
