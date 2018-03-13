class BrandTest < ActiveSupport::TestCase

  test "brand list detail detail_ids" do
    params = {}
    list_data = Auction::Brand.list(params)
    assert_equal list_data["comm"]["code"], "200", "商品详情：params:#{params}\r\n response: #{list_data}"

    params = {brandsId: list_data["data"].first["id"]}
    detail_data = Auction::Brand.detail(params)
    assert_equal detail_data["comm"]["code"], "200", "商品详情：params:#{params}\r\n response: #{detail_data}"

    params = {brandsIds: list_data["data"].map{|x| x["id"]}.join(",") }
    data = Auction::Brand.detail_ids(params)
    assert_equal data["comm"]["code"], "200", "商品详情：params:#{params}\r\n response: #{data}"
  end
end
