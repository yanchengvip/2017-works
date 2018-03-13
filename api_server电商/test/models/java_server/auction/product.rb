# require 'test_helper'
class ProductTest < ActiveSupport::TestCase

  test "product getProduct" do
    product = Auction::Product.where(published: true).active.last
    params = {product_id: product.id}
    data = Auction::Product.getProduct(params)
    assert_equal data["comm"]["code"], "200", "商品详情：params:#{params}\r\n response: #{data}"
  end

end
