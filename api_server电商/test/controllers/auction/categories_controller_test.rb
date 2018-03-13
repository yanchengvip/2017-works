require 'test_helper'

class Auction::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_category = auction_categories(:one)
  end

  test "should get index" do
    get auction_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_category_url
    assert_response :success
  end

  test "should create auction_category" do
    assert_difference('Auction::Category.count') do
      post auction_categories_url, params: { auction_category: {  } }
    end

    assert_redirected_to auction_category_url(Auction::Category.last)
  end

  test "should show auction_category" do
    get auction_category_url(@auction_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_category_url(@auction_category)
    assert_response :success
  end

  test "should update auction_category" do
    patch auction_category_url(@auction_category), params: { auction_category: {  } }
    assert_redirected_to auction_category_url(@auction_category)
  end

  test "should destroy auction_category" do
    assert_difference('Auction::Category.count', -1) do
      delete auction_category_url(@auction_category)
    end

    assert_redirected_to auction_categories_url
  end
end
