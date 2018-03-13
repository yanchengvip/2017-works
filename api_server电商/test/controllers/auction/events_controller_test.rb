require 'test_helper'

class Auction::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_event = auction_events(:one)
  end

  test "should get index" do
    get auction_events_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_event_url
    assert_response :success
  end

  test "should create auction_event" do
    assert_difference('Auction::Event.count') do
      post auction_events_url, params: { auction_event: {  } }
    end

    assert_redirected_to auction_event_url(Auction::Event.last)
  end

  test "should show auction_event" do
    get auction_event_url(@auction_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_event_url(@auction_event)
    assert_response :success
  end

  test "should update auction_event" do
    patch auction_event_url(@auction_event), params: { auction_event: {  } }
    assert_redirected_to auction_event_url(@auction_event)
  end

  test "should destroy auction_event" do
    assert_difference('Auction::Event.count', -1) do
      delete auction_event_url(@auction_event)
    end

    assert_redirected_to auction_events_url
  end
end
