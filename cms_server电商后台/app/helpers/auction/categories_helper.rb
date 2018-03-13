module Auction::CategoriesHelper

  def attributes_name attribute_ids
    Auction::ProductAttribute.where(id: attribute_ids&.split(',')&.map(&:to_i))&.pluck(:name)&.join(',')
  end

end
