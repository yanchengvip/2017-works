require 'test_helper'

class Auction::TownsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_town = auction_towns(:one)
  end

  test "should get index" do
    get auction_towns_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_town_url
    assert_response :success
  end

  test "should create auction_town" do
    assert_difference('Auction::Town.count') do
      post auction_towns_url, params: { auction_town: {  } }
    end

    assert_redirected_to auction_town_url(Auction::Town.last)
  end

  test "should show auction_town" do
    get auction_town_url(@auction_town)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_town_url(@auction_town)
    assert_response :success
  end

  test "should update auction_town" do
    patch auction_town_url(@auction_town), params: { auction_town: {  } }
    assert_redirected_to auction_town_url(@auction_town)
  end

  test "should destroy auction_town" do
    assert_difference('Auction::Town.count', -1) do
      delete auction_town_url(@auction_town)
    end

    assert_redirected_to auction_towns_url
  end
end
