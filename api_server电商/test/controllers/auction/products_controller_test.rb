require 'test_helper'

class Auction::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_product = auction_products(:one)
  end

  test "should get index" do
    get auction_products_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_product_url
    assert_response :success
  end

  test "should create auction_product" do
    assert_difference('Auction::Product.count') do
      post auction_products_url, params: { auction_product: {  } }
    end

    assert_redirected_to auction_product_url(Auction::Product.last)
  end

  test "should show auction_product" do
    get auction_product_url(@auction_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_product_url(@auction_product)
    assert_response :success
  end

  test "should update auction_product" do
    patch auction_product_url(@auction_product), params: { auction_product: {  } }
    assert_redirected_to auction_product_url(@auction_product)
  end

  test "should destroy auction_product" do
    assert_difference('Auction::Product.count', -1) do
      delete auction_product_url(@auction_product)
    end

    assert_redirected_to auction_products_url
  end
end
