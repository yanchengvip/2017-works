require 'test_helper'

class Auction::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_user = auction_users(:one)
  end

  test "should get index" do
    get auction_users_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_user_url
    assert_response :success
  end

  test "should create auction_user" do
    assert_difference('Auction::User.count') do
      post auction_users_url, params: { auction_user: {  } }
    end

    assert_redirected_to auction_user_url(Auction::User.last)
  end

  test "should show auction_user" do
    get auction_user_url(@auction_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_user_url(@auction_user)
    assert_response :success
  end

  test "should update auction_user" do
    patch auction_user_url(@auction_user), params: { auction_user: {  } }
    assert_redirected_to auction_user_url(@auction_user)
  end

  test "should destroy auction_user" do
    assert_difference('Auction::User.count', -1) do
      delete auction_user_url(@auction_user)
    end

    assert_redirected_to auction_users_url
  end
end
