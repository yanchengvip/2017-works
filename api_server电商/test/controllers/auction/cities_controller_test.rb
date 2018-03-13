require 'test_helper'

class Auction::CitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_city = auction_cities(:one)
  end

  test "should get index" do
    get auction_cities_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_city_url
    assert_response :success
  end

  test "should create auction_city" do
    assert_difference('Auction::City.count') do
      post auction_cities_url, params: { auction_city: {  } }
    end

    assert_redirected_to auction_city_url(Auction::City.last)
  end

  test "should show auction_city" do
    get auction_city_url(@auction_city)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_city_url(@auction_city)
    assert_response :success
  end

  test "should update auction_city" do
    patch auction_city_url(@auction_city), params: { auction_city: {  } }
    assert_redirected_to auction_city_url(@auction_city)
  end

  test "should destroy auction_city" do
    assert_difference('Auction::City.count', -1) do
      delete auction_city_url(@auction_city)
    end

    assert_redirected_to auction_cities_url
  end
end
