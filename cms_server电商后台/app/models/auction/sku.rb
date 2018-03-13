class Auction::Sku < ApplicationRecord
  belongs_to :product
  belongs_to :supplier_product, :class_name => "Supplier::Product", foreign_key: "product_id"
  after_save :cal_unsold_count

  def cal_unsold_count
    begin
      self.product.update(unsold_count: self.product.skus.sum(:amount))
    rescue Exception => e
    end
  end
end
