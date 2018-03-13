require 'test_helper'

class Auction::ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_contact = auction_contacts(:one)
  end

  test "should get index" do
    get auction_contacts_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_contact_url
    assert_response :success
  end

  test "should create auction_contact" do
    assert_difference('Auction::Contact.count') do
      post auction_contacts_url, params: { auction_contact: {  } }
    end

    assert_redirected_to auction_contact_url(Auction::Contact.last)
  end

  test "should show auction_contact" do
    get auction_contact_url(@auction_contact)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_contact_url(@auction_contact)
    assert_response :success
  end

  test "should update auction_contact" do
    patch auction_contact_url(@auction_contact), params: { auction_contact: {  } }
    assert_redirected_to auction_contact_url(@auction_contact)
  end

  test "should destroy auction_contact" do
    assert_difference('Auction::Contact.count', -1) do
      delete auction_contact_url(@auction_contact)
    end

    assert_redirected_to auction_contacts_url
  end
end
