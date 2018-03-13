require 'test_helper'

class Auction::VoucherTradesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_voucher_trade = auction_voucher_trades(:one)
  end

  test "should get index" do
    get auction_voucher_trades_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_voucher_trade_url
    assert_response :success
  end

  test "should create auction_voucher_trade" do
    assert_difference('Auction::VoucherTrade.count') do
      post auction_voucher_trades_url, params: { auction_voucher_trade: {  } }
    end

    assert_redirected_to auction_voucher_trade_url(Auction::VoucherTrade.last)
  end

  test "should show auction_voucher_trade" do
    get auction_voucher_trade_url(@auction_voucher_trade)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_voucher_trade_url(@auction_voucher_trade)
    assert_response :success
  end

  test "should update auction_voucher_trade" do
    patch auction_voucher_trade_url(@auction_voucher_trade), params: { auction_voucher_trade: {  } }
    assert_redirected_to auction_voucher_trade_url(@auction_voucher_trade)
  end

  test "should destroy auction_voucher_trade" do
    assert_difference('Auction::VoucherTrade.count', -1) do
      delete auction_voucher_trade_url(@auction_voucher_trade)
    end

    assert_redirected_to auction_voucher_trades_url
  end
end
