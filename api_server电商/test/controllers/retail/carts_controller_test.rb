require 'test_helper'

class Retail::CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @retail_cart = retail_carts(:one)
  end

  test "should get index" do
    get retail_carts_url
    assert_response :success
  end

  test "should get new" do
    get new_retail_cart_url
    assert_response :success
  end

  test "should create retail_cart" do
    assert_difference('Retail::Cart.count') do
      post retail_carts_url, params: { retail_cart: {  } }
    end

    assert_redirected_to retail_cart_url(Retail::Cart.last)
  end

  test "should show retail_cart" do
    get retail_cart_url(@retail_cart)
    assert_response :success
  end

  test "should get edit" do
    get edit_retail_cart_url(@retail_cart)
    assert_response :success
  end

  test "should update retail_cart" do
    patch retail_cart_url(@retail_cart), params: { retail_cart: {  } }
    assert_redirected_to retail_cart_url(@retail_cart)
  end

  test "should destroy retail_cart" do
    assert_difference('Retail::Cart.count', -1) do
      delete retail_cart_url(@retail_cart)
    end

    assert_redirected_to retail_carts_url
  end
end
