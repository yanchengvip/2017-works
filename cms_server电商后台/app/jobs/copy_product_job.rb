class CopyProductJob < ApplicationJob
  queue_as :default

  def perform( provider_id, product_id)
    if product = Supplier::Product.where(id: product_id).first
      json =  product.as_json.merge(provider_id: provider_id)
      json.delete("id")
      copy_product = Supplier::Product.create(json)
      sku_json = product.skus.select(:name, :amount, :code).as_json
      sku_json.map{|x| x.delete("id")}
      copy_product.skus.create(product.skus.select(:name, :amount, :code).as_json)
      copy_product.images.create product.images.select(:sequence, :large, :user_id, :active, :description).as_json
      copy_product.values.create product.values.select(:editor_id, :attribute_id, :content, :active, :attribute_name).as_json
    end
  end
end
