require 'test_helper'

class Auction::TradesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_trade = auction_trades(:one)
  end

  test "should get index" do
    get auction_trades_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_trade_url
    assert_response :success
  end

  test "should create auction_trade" do
    assert_difference('Auction::Trade.count') do
      post auction_trades_url, params: { auction_trade: {  } }
    end

    assert_redirected_to auction_trade_url(Auction::Trade.last)
  end

  test "should show auction_trade" do
    get auction_trade_url(@auction_trade)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_trade_url(@auction_trade)
    assert_response :success
  end

  test "should update auction_trade" do
    patch auction_trade_url(@auction_trade), params: { auction_trade: {  } }
    assert_redirected_to auction_trade_url(@auction_trade)
  end

  test "should destroy auction_trade" do
    assert_difference('Auction::Trade.count', -1) do
      delete auction_trade_url(@auction_trade)
    end

    assert_redirected_to auction_trades_url
  end
end
