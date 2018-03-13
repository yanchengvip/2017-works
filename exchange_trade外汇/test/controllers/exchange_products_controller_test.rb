require 'test_helper'

class ExchangeProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exchange_product = exchange_products(:one)
  end

  test "should get index" do
    get exchange_products_url
    assert_response :success
  end

  test "should get new" do
    get new_exchange_product_url
    assert_response :success
  end

  test "should create exchange_product" do
    assert_difference('ExchangeProduct.count') do
      post exchange_products_url, params: { exchange_product: { active: @exchange_product.active, published: @exchange_product.published, symbol: @exchange_product.symbol } }
    end

    assert_redirected_to exchange_product_url(ExchangeProduct.last)
  end

  test "should show exchange_product" do
    get exchange_product_url(@exchange_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_exchange_product_url(@exchange_product)
    assert_response :success
  end

  test "should update exchange_product" do
    patch exchange_product_url(@exchange_product), params: { exchange_product: { active: @exchange_product.active, published: @exchange_product.published, symbol: @exchange_product.symbol } }
    assert_redirected_to exchange_product_url(@exchange_product)
  end

  test "should destroy exchange_product" do
    assert_difference('ExchangeProduct.count', -1) do
      delete exchange_product_url(@exchange_product)
    end

    assert_redirected_to exchange_products_url
  end
end
