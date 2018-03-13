require 'test_helper'

class Mammon::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mammon_card = mammon_cards(:one)
  end

  test "should get index" do
    get mammon_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_mammon_card_url
    assert_response :success
  end

  test "should create mammon_card" do
    assert_difference('Mammon::Card.count') do
      post mammon_cards_url, params: { mammon_card: { name: @mammon_card.name, num: @mammon_card.num } }
    end

    assert_redirected_to mammon_card_url(Mammon::Card.last)
  end

  test "should show mammon_card" do
    get mammon_card_url(@mammon_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_mammon_card_url(@mammon_card)
    assert_response :success
  end

  test "should update mammon_card" do
    patch mammon_card_url(@mammon_card), params: { mammon_card: { name: @mammon_card.name, num: @mammon_card.num } }
    assert_redirected_to mammon_card_url(@mammon_card)
  end

  test "should destroy mammon_card" do
    assert_difference('Mammon::Card.count', -1) do
      delete mammon_card_url(@mammon_card)
    end

    assert_redirected_to mammon_cards_url
  end
end
