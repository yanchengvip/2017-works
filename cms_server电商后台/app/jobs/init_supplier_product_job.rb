class InitSupplierProductJob < ApplicationJob
  queue_as :default

  def perform(product)
    Supplier::Product.create(product)
    # Do something later
  end
end
