require 'test_helper'

class Auction::BrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_brand = auction_brands(:one)
  end

  test "should get index" do
    get auction_brands_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_brand_url
    assert_response :success
  end

  test "should create auction_brand" do
    assert_difference('Auction::Brand.count') do
      post auction_brands_url, params: { auction_brand: {  } }
    end

    assert_redirected_to auction_brand_url(Auction::Brand.last)
  end

  test "should show auction_brand" do
    get auction_brand_url(@auction_brand)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_brand_url(@auction_brand)
    assert_response :success
  end

  test "should update auction_brand" do
    patch auction_brand_url(@auction_brand), params: { auction_brand: {  } }
    assert_redirected_to auction_brand_url(@auction_brand)
  end

  test "should destroy auction_brand" do
    assert_difference('Auction::Brand.count', -1) do
      delete auction_brand_url(@auction_brand)
    end

    assert_redirected_to auction_brands_url
  end
end
