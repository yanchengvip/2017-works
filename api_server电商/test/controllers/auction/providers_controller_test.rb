require 'test_helper'

class Auction::ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_provider = auction_providers(:one)
  end

  test "should get index" do
    get auction_providers_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_provider_url
    assert_response :success
  end

  test "should create auction_provider" do
    assert_difference('Auction::Provider.count') do
      post auction_providers_url, params: { auction_provider: {  } }
    end

    assert_redirected_to auction_provider_url(Auction::Provider.last)
  end

  test "should show auction_provider" do
    get auction_provider_url(@auction_provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_provider_url(@auction_provider)
    assert_response :success
  end

  test "should update auction_provider" do
    patch auction_provider_url(@auction_provider), params: { auction_provider: {  } }
    assert_redirected_to auction_provider_url(@auction_provider)
  end

  test "should destroy auction_provider" do
    assert_difference('Auction::Provider.count', -1) do
      delete auction_provider_url(@auction_provider)
    end

    assert_redirected_to auction_providers_url
  end
end
