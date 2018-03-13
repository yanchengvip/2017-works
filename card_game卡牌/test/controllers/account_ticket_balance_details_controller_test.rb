require 'test_helper'

class AccountTicketBalanceDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_ticket_balance_detail = account_ticket_balance_details(:one)
  end

  test "should get index" do
    get account_ticket_balance_details_url
    assert_response :success
  end

  test "should get new" do
    get new_account_ticket_balance_detail_url
    assert_response :success
  end

  test "should create account_ticket_balance_detail" do
    assert_difference('AccountTicketBalanceDetail.count') do
      post account_ticket_balance_details_url, params: { account_ticket_balance_detail: { account_ticket_id: @account_ticket_balance_detail.account_ticket_id, fund: @account_ticket_balance_detail.fund, trad_type: @account_ticket_balance_detail.trad_type, user_id: @account_ticket_balance_detail.user_id } }
    end

    assert_redirected_to account_ticket_balance_detail_url(AccountTicketBalanceDetail.last)
  end

  test "should show account_ticket_balance_detail" do
    get account_ticket_balance_detail_url(@account_ticket_balance_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_ticket_balance_detail_url(@account_ticket_balance_detail)
    assert_response :success
  end

  test "should update account_ticket_balance_detail" do
    patch account_ticket_balance_detail_url(@account_ticket_balance_detail), params: { account_ticket_balance_detail: { account_ticket_id: @account_ticket_balance_detail.account_ticket_id, fund: @account_ticket_balance_detail.fund, trad_type: @account_ticket_balance_detail.trad_type, user_id: @account_ticket_balance_detail.user_id } }
    assert_redirected_to account_ticket_balance_detail_url(@account_ticket_balance_detail)
  end

  test "should destroy account_ticket_balance_detail" do
    assert_difference('AccountTicketBalanceDetail.count', -1) do
      delete account_ticket_balance_detail_url(@account_ticket_balance_detail)
    end

    assert_redirected_to account_ticket_balance_details_url
  end
end
