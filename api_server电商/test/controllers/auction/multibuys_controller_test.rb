require 'test_helper'

class Auction::MultibuysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_multibuy = auction_multibuys(:one)
  end

  test "should get index" do
    get auction_multibuys_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_multibuy_url
    assert_response :success
  end

  test "should create auction_multibuy" do
    assert_difference('Auction::Multibuy.count') do
      post auction_multibuys_url, params: { auction_multibuy: {  } }
    end

    assert_redirected_to auction_multibuy_url(Auction::Multibuy.last)
  end

  test "should show auction_multibuy" do
    get auction_multibuy_url(@auction_multibuy)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_multibuy_url(@auction_multibuy)
    assert_response :success
  end

  test "should update auction_multibuy" do
    patch auction_multibuy_url(@auction_multibuy), params: { auction_multibuy: {  } }
    assert_redirected_to auction_multibuy_url(@auction_multibuy)
  end

  test "should destroy auction_multibuy" do
    assert_difference('Auction::Multibuy.count', -1) do
      delete auction_multibuy_url(@auction_multibuy)
    end

    assert_redirected_to auction_multibuys_url
  end
end
