require 'test_helper'

class Auction::AttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_attribute = auction_attributes(:one)
  end

  test "should get index" do
    get auction_attributes_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_attribute_url
    assert_response :success
  end

  test "should create auction_attribute" do
    assert_difference('Auction::Attribute.count') do
      post auction_attributes_url, params: { auction_attribute: {  } }
    end

    assert_redirected_to auction_attribute_url(Auction::Attribute.last)
  end

  test "should show auction_attribute" do
    get auction_attribute_url(@auction_attribute)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_attribute_url(@auction_attribute)
    assert_response :success
  end

  test "should update auction_attribute" do
    patch auction_attribute_url(@auction_attribute), params: { auction_attribute: {  } }
    assert_redirected_to auction_attribute_url(@auction_attribute)
  end

  test "should destroy auction_attribute" do
    assert_difference('Auction::Attribute.count', -1) do
      delete auction_attribute_url(@auction_attribute)
    end

    assert_redirected_to auction_attributes_url
  end
end
