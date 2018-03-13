require 'test_helper'

class Auction::ValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_value = auction_values(:one)
  end

  test "should get index" do
    get auction_values_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_value_url
    assert_response :success
  end

  test "should create auction_value" do
    assert_difference('Auction::Value.count') do
      post auction_values_url, params: { auction_value: {  } }
    end

    assert_redirected_to auction_value_url(Auction::Value.last)
  end

  test "should show auction_value" do
    get auction_value_url(@auction_value)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_value_url(@auction_value)
    assert_response :success
  end

  test "should update auction_value" do
    patch auction_value_url(@auction_value), params: { auction_value: {  } }
    assert_redirected_to auction_value_url(@auction_value)
  end

  test "should destroy auction_value" do
    assert_difference('Auction::Value.count', -1) do
      delete auction_value_url(@auction_value)
    end

    assert_redirected_to auction_values_url
  end
end
