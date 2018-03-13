require 'test_helper'

class Mammon::UserCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mammon_user_card = mammon_user_cards(:one)
  end

  test "should get index" do
    get mammon_user_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_mammon_user_card_url
    assert_response :success
  end

  test "should create mammon_user_card" do
    assert_difference('Mammon::UserCard.count') do
      post mammon_user_cards_url, params: { mammon_user_card: { user_id: @mammon_user_card.user_id } }
    end

    assert_redirected_to mammon_user_card_url(Mammon::UserCard.last)
  end

  test "should show mammon_user_card" do
    get mammon_user_card_url(@mammon_user_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_mammon_user_card_url(@mammon_user_card)
    assert_response :success
  end

  test "should update mammon_user_card" do
    patch mammon_user_card_url(@mammon_user_card), params: { mammon_user_card: { user_id: @mammon_user_card.user_id } }
    assert_redirected_to mammon_user_card_url(@mammon_user_card)
  end

  test "should destroy mammon_user_card" do
    assert_difference('Mammon::UserCard.count', -1) do
      delete mammon_user_card_url(@mammon_user_card)
    end

    assert_redirected_to mammon_user_cards_url
  end
end
