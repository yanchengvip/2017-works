require 'test_helper'

class Auction::FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_favorite = auction_favorites(:one)
  end

  test "should get index" do
    get auction_favorites_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_favorite_url
    assert_response :success
  end

  test "should create auction_favorite" do
    assert_difference('Auction::Favorite.count') do
      post auction_favorites_url, params: { auction_favorite: {  } }
    end

    assert_redirected_to auction_favorite_url(Auction::Favorite.last)
  end

  test "should show auction_favorite" do
    get auction_favorite_url(@auction_favorite)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_favorite_url(@auction_favorite)
    assert_response :success
  end

  test "should update auction_favorite" do
    patch auction_favorite_url(@auction_favorite), params: { auction_favorite: {  } }
    assert_redirected_to auction_favorite_url(@auction_favorite)
  end

  test "should destroy auction_favorite" do
    assert_difference('Auction::Favorite.count', -1) do
      delete auction_favorite_url(@auction_favorite)
    end

    assert_redirected_to auction_favorites_url
  end
end
