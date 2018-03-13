require 'test_helper'

class Auction::CouponsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_coupon = auction_coupons(:one)
  end

  test "should get index" do
    get auction_coupons_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_coupon_url
    assert_response :success
  end

  test "should create auction_coupon" do
    assert_difference('Auction::Coupon.count') do
      post auction_coupons_url, params: { auction_coupon: {  } }
    end

    assert_redirected_to auction_coupon_url(Auction::Coupon.last)
  end

  test "should show auction_coupon" do
    get auction_coupon_url(@auction_coupon)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_coupon_url(@auction_coupon)
    assert_response :success
  end

  test "should update auction_coupon" do
    patch auction_coupon_url(@auction_coupon), params: { auction_coupon: {  } }
    assert_redirected_to auction_coupon_url(@auction_coupon)
  end

  test "should destroy auction_coupon" do
    assert_difference('Auction::Coupon.count', -1) do
      delete auction_coupon_url(@auction_coupon)
    end

    assert_redirected_to auction_coupons_url
  end
end
