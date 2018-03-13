require 'test_helper'

class Auction::UnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_unit = auction_units(:one)
  end

  test "should get index" do
    get auction_units_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_unit_url
    assert_response :success
  end

  test "should create auction_unit" do
    assert_difference('Auction::Unit.count') do
      post auction_units_url, params: { auction_unit: {  } }
    end

    assert_redirected_to auction_unit_url(Auction::Unit.last)
  end

  test "should show auction_unit" do
    get auction_unit_url(@auction_unit)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_unit_url(@auction_unit)
    assert_response :success
  end

  test "should update auction_unit" do
    patch auction_unit_url(@auction_unit), params: { auction_unit: {  } }
    assert_redirected_to auction_unit_url(@auction_unit)
  end

  test "should destroy auction_unit" do
    assert_difference('Auction::Unit.count', -1) do
      delete auction_unit_url(@auction_unit)
    end

    assert_redirected_to auction_units_url
  end
end
