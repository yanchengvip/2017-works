require 'test_helper'

class Auction::VouchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_voucher = auction_vouchers(:one)
  end

  test "should get index" do
    get auction_vouchers_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_voucher_url
    assert_response :success
  end

  test "should create auction_voucher" do
    assert_difference('Auction::Voucher.count') do
      post auction_vouchers_url, params: { auction_voucher: {  } }
    end

    assert_redirected_to auction_voucher_url(Auction::Voucher.last)
  end

  test "should show auction_voucher" do
    get auction_voucher_url(@auction_voucher)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_voucher_url(@auction_voucher)
    assert_response :success
  end

  test "should update auction_voucher" do
    patch auction_voucher_url(@auction_voucher), params: { auction_voucher: {  } }
    assert_redirected_to auction_voucher_url(@auction_voucher)
  end

  test "should destroy auction_voucher" do
    assert_difference('Auction::Voucher.count', -1) do
      delete auction_voucher_url(@auction_voucher)
    end

    assert_redirected_to auction_vouchers_url
  end
end
