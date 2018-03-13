class FanshipTest < ActiveSupport::TestCase

  test "Fanship list detail detail_ids" do
    user_id = Setting.test["user_id"]
    #列表
    params = {"pageNo": 1, "pageSize": 10, userId: user_id}
    list_data = Auction::Fanship.list(params)
    assert_equal list_data["comm"]["code"], "200", "收藏品牌列表：params:#{params}\r\n response: #{list_data}"

    brand = Auction::Brand.where(published: true).active.last

    #是否已经收藏过
    params = {brand_id: brand.id, user_id: user_id}
    is_collect_data = Auction::Fanship.isBrandCollect(params)
    assert_equal is_collect_data["comm"]["code"], "200", "成功：params:#{params}\r\n response: #{is_collect_data}"

    if is_collect_data["data"] == true
      #先删除再收藏
      params = {user_id: user_id, brand_id: brand.id}
      delete_data = Auction::Fanship.delete(params)
      assert_equal delete_data["comm"]["code"], "200", "删除成功：params:#{params}\r\n response: #{delete_data}"

      params = {user_id: user_id, brand_id: brand.id}
      insert_data = Auction::Fanship.insert(params)
      assert_equal insert_data["comm"]["code"], "200", "添加成功：params:#{params}\r\n response: #{insert_data}"
    else

      #先收藏再删除
      params = {user_id: user_id, brand_id: brand.id}
      insert_data = Auction::Fanship.insert(params)
      assert_equal insert_data["comm"]["code"], "200", "添加成功：params:#{params}\r\n response: #{insert_data}"

      params = {user_id: user_id, brand_id: brand.id}
      delete_data = Auction::Fanship.delete(params)
      assert_equal delete_data["comm"]["code"], "200", "删除成功：params:#{params}\r\n response: #{delete_data}"
    end


  end
end
