require 'test_helper'

class Auction::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_card = auction_cards(:one)
  end

  test "should get index" do
    get auction_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_card_url
    assert_response :success
  end

  test "should create auction_card" do
    assert_difference('Auction::Card.count') do
      post auction_cards_url, params: { auction_card: {  } }
    end

    assert_redirected_to auction_card_url(Auction::Card.last)
  end

  test "should show auction_card" do
    get auction_card_url(@auction_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_card_url(@auction_card)
    assert_response :success
  end

  test "should update auction_card" do
    patch auction_card_url(@auction_card), params: { auction_card: {  } }
    assert_redirected_to auction_card_url(@auction_card)
  end

  test "should destroy auction_card" do
    assert_difference('Auction::Card.count', -1) do
      delete auction_card_url(@auction_card)
    end

    assert_redirected_to auction_cards_url
  end
end
