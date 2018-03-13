require 'test_helper'

class Auction::SmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_sm = auction_sms(:one)
  end

  test "should get index" do
    get auction_sms_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_sm_url
    assert_response :success
  end

  test "should create auction_sm" do
    assert_difference('Auction::Sm.count') do
      post auction_sms_url, params: { auction_sm: {  } }
    end

    assert_redirected_to auction_sm_url(Auction::Sm.last)
  end

  test "should show auction_sm" do
    get auction_sm_url(@auction_sm)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_sm_url(@auction_sm)
    assert_response :success
  end

  test "should update auction_sm" do
    patch auction_sm_url(@auction_sm), params: { auction_sm: {  } }
    assert_redirected_to auction_sm_url(@auction_sm)
  end

  test "should destroy auction_sm" do
    assert_difference('Auction::Sm.count', -1) do
      delete auction_sm_url(@auction_sm)
    end

    assert_redirected_to auction_sms_url
  end
end
