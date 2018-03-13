class CategoryTest < ActiveSupport::TestCase

  test "Category list" do
    params = {categoryId: ""}
    list_data = Auction::Category.list(params)
    assert_equal list_data["comm"]["code"], "200", "分类列表：params:#{params}\r\n response: #{list_data}"
  end
end
