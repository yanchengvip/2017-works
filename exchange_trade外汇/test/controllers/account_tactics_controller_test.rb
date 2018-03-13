require 'test_helper'

class AccountTacticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_tactic = account_tactics(:one)
  end

  test "should get index" do
    get account_tactics_url
    assert_response :success
  end

  test "should get new" do
    get new_account_tactic_url
    assert_response :success
  end

  test "should create account_tactic" do
    assert_difference('AccountTactic.count') do
      post account_tactics_url, params: { account_tactic: { account_id: @account_tactic.account_id, active: @account_tactic.active, dealer_id: @account_tactic.dealer_id, dealer_type: @account_tactic.dealer_type, follow_money: @account_tactic.follow_money, tactic_id: @account_tactic.tactic_id } }
    end

    assert_redirected_to account_tactic_url(AccountTactic.last)
  end

  test "should show account_tactic" do
    get account_tactic_url(@account_tactic)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_tactic_url(@account_tactic)
    assert_response :success
  end

  test "should update account_tactic" do
    patch account_tactic_url(@account_tactic), params: { account_tactic: { account_id: @account_tactic.account_id, active: @account_tactic.active, dealer_id: @account_tactic.dealer_id, dealer_type: @account_tactic.dealer_type, follow_money: @account_tactic.follow_money, tactic_id: @account_tactic.tactic_id } }
    assert_redirected_to account_tactic_url(@account_tactic)
  end

  test "should destroy account_tactic" do
    assert_difference('AccountTactic.count', -1) do
      delete account_tactic_url(@account_tactic)
    end

    assert_redirected_to account_tactics_url
  end
end
