require 'test_helper'

class Auction::CountriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_country = auction_countries(:one)
  end

  test "should get index" do
    get auction_countries_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_country_url
    assert_response :success
  end

  test "should create auction_country" do
    assert_difference('Auction::Country.count') do
      post auction_countries_url, params: { auction_country: {  } }
    end

    assert_redirected_to auction_country_url(Auction::Country.last)
  end

  test "should show auction_country" do
    get auction_country_url(@auction_country)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_country_url(@auction_country)
    assert_response :success
  end

  test "should update auction_country" do
    patch auction_country_url(@auction_country), params: { auction_country: {  } }
    assert_redirected_to auction_country_url(@auction_country)
  end

  test "should destroy auction_country" do
    assert_difference('Auction::Country.count', -1) do
      delete auction_country_url(@auction_country)
    end

    assert_redirected_to auction_countries_url
  end
end
