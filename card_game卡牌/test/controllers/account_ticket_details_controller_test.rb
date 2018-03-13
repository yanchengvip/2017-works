require 'test_helper'

class AccountTicketDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get account_ticket_details_index_url
    assert_response :success
  end

end
