class ContactTest < ActiveSupport::TestCase

  test "contact list detail detail_ids" do
    user_id = Setting.test["user_id"]
    #列表
    params = {"pageNo": 1, "pageSize": 10, userId: user_id}
    list_data = Auction::Contact.listCarts(params)
    assert_equal list_data["comm"]["code"], "200", "收货地址：params:#{params}\r\n response: #{list_data}"

     #添加
    params = {name: "name",province: "sic", city: "nanc", town: "nanb",address: "sicnancnanb", postcode: "11111", phone: "18518639588",id_number: "1111",is_default: false, userId: user_id}
    insert_data = Auction::Contact.insertContacts(params)
    assert_equal insert_data["comm"]["code"], "200", "创建成功：params:#{params}\r\n response: #{insert_data}"

    if insert_data["data"]

      #修改
      params = {id: insert_data["data"]["id"], name: "name",province: "sic", city: "nanc", town: "nanb",address: "sicnancnanb", postcode: "11111", phone: "18518639588",id_number: "1111",is_default: false, userId: user_id}
      update_data = Auction::Contact.updateContacts(params)
      assert_equal update_data["comm"]["code"], "200", "修改成功：params:#{params}\r\n response: #{update_data}"

      #设置默认地址
      params = {areaId: update_data["data"]["id"], userId: user_id}
      default_data = Auction::Contact.setDefaultContact(params)
      assert_equal default_data["comm"]["code"], "200", "设置默认地址成功：params:#{params}\r\n response: #{default_data}"

      #删除
      params = {addressId: default_data["data"]["id"], userId: user_id}
      delete_data = Auction::Contact.deleteContacts(params)
      assert_equal delete_data["comm"]["code"], "200", "删除成功：params:#{params}\r\n response: #{delete_data}"

    end

  end

end
