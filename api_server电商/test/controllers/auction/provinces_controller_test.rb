require 'test_helper'

class Auction::ProvincesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_province = auction_provinces(:one)
  end

  test "should get index" do
    get auction_provinces_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_province_url
    assert_response :success
  end

  test "should create auction_province" do
    assert_difference('Auction::Province.count') do
      post auction_provinces_url, params: { auction_province: {  } }
    end

    assert_redirected_to auction_province_url(Auction::Province.last)
  end

  test "should show auction_province" do
    get auction_province_url(@auction_province)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_province_url(@auction_province)
    assert_response :success
  end

  test "should update auction_province" do
    patch auction_province_url(@auction_province), params: { auction_province: {  } }
    assert_redirected_to auction_province_url(@auction_province)
  end

  test "should destroy auction_province" do
    assert_difference('Auction::Province.count', -1) do
      delete auction_province_url(@auction_province)
    end

    assert_redirected_to auction_provinces_url
  end
end
