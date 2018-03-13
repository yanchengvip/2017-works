require 'test_helper'

class Auction::TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auction_transaction = auction_transactions(:one)
  end

  test "should get index" do
    get auction_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_auction_transaction_url
    assert_response :success
  end

  test "should create auction_transaction" do
    assert_difference('Auction::Transaction.count') do
      post auction_transactions_url, params: { auction_transaction: {  } }
    end

    assert_redirected_to auction_transaction_url(Auction::Transaction.last)
  end

  test "should show auction_transaction" do
    get auction_transaction_url(@auction_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_auction_transaction_url(@auction_transaction)
    assert_response :success
  end

  test "should update auction_transaction" do
    patch auction_transaction_url(@auction_transaction), params: { auction_transaction: {  } }
    assert_redirected_to auction_transaction_url(@auction_transaction)
  end

  test "should destroy auction_transaction" do
    assert_difference('Auction::Transaction.count', -1) do
      delete auction_transaction_url(@auction_transaction)
    end

    assert_redirected_to auction_transactions_url
  end
end
