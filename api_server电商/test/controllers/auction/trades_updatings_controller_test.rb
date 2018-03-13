require 'test_helper'

class Auction::TradesUpdatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_trades_updating = auction_trades_updatings(:one)
  end

  test "should get index" do
    get auction_trades_updatings_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_trades_updating_url
    assert_response :success
  end

  test "should create auction_trades_updating" do
    assert_difference('Auction::TradesUpdating.count') do
      post auction_trades_updatings_url, params: { auction_trades_updating: {  } }
    end

    assert_redirected_to auction_trades_updating_url(Auction::TradesUpdating.last)
  end

  test "should show auction_trades_updating" do
    get auction_trades_updating_url(@auction_trades_updating)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_trades_updating_url(@auction_trades_updating)
    assert_response :success
  end

  test "should update auction_trades_updating" do
    patch auction_trades_updating_url(@auction_trades_updating), params: { auction_trades_updating: {  } }
    assert_redirected_to auction_trades_updating_url(@auction_trades_updating)
  end

  test "should destroy auction_trades_updating" do
    assert_difference('Auction::TradesUpdating.count', -1) do
      delete auction_trades_updating_url(@auction_trades_updating)
    end

    assert_redirected_to auction_trades_updatings_url
  end
end
