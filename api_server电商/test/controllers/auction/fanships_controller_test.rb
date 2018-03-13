require 'test_helper'

class Auction::FanshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_fanship = auction_fanships(:one)
  end

  test "should get index" do
    get auction_fanships_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_fanship_url
    assert_response :success
  end

  test "should create auction_fanship" do
    assert_difference('Auction::Fanship.count') do
      post auction_fanships_url, params: { auction_fanship: {  } }
    end

    assert_redirected_to auction_fanship_url(Auction::Fanship.last)
  end

  test "should show auction_fanship" do
    get auction_fanship_url(@auction_fanship)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_fanship_url(@auction_fanship)
    assert_response :success
  end

  test "should update auction_fanship" do
    patch auction_fanship_url(@auction_fanship), params: { auction_fanship: {  } }
    assert_redirected_to auction_fanship_url(@auction_fanship)
  end

  test "should destroy auction_fanship" do
    assert_difference('Auction::Fanship.count', -1) do
      delete auction_fanship_url(@auction_fanship)
    end

    assert_redirected_to auction_fanships_url
  end
end
