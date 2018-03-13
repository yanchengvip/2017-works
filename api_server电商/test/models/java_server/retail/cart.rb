class CartTest < ActiveSupport::TestCase

  test "cart list detail detail_ids" do
    user_id = Setting.test["user_id"]
    #购物车列表
    params = {'userId': user_id}
    cart_data = Retail::Cart.carts(params)
    assert_equal cart_data["comm"]["code"], "200", "购物车列表：params:#{params}\r\n response: #{cart_data}"

    product = Auction::Product.where(published: true).active.last
    sku = Auction::Sku.active.last

    #添加购物车
    params = {'userId': 1, 'productId': product.id, 'skuId': sku.id,'client': "iphone"}
    insert_data = Retail::Cart.insertCarts(params)
    assert_equal insert_data["comm"]["code"], "200", "添加成功：params:#{params}\r\n response: #{insert_data}"

    if insert_data["data"]["retail_cart"]
      #删除购物车
      params = { 'cartId': insert_data['data']["retail_cart"]["id"], 'userId': user_id}
      delete_data = Retail::Cart.deleteCarts(params)
      assert_equal delete_data["comm"]["code"], "200", "删除成功：params:#{params}\r\n response: #{delete_data}"
    end


  end
end
