require 'test_helper'

class ExchangeProductPriceLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exchange_product_price_log = exchange_product_price_logs(:one)
  end

  test "should get index" do
    get exchange_product_price_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_exchange_product_price_log_url
    assert_response :success
  end

  test "should create exchange_product_price_log" do
    assert_difference('ExchangeProductPriceLog.count') do
      post exchange_product_price_logs_url, params: { exchange_product_price_log: { active: @exchange_product_price_log.active, dealer_id: @exchange_product_price_log.dealer_id, dealer_type: @exchange_product_price_log.dealer_type, exchange_product_id: @exchange_product_price_log.exchange_product_id, price: @exchange_product_price_log.price, time: @exchange_product_price_log.time } }
    end

    assert_redirected_to exchange_product_price_log_url(ExchangeProductPriceLog.last)
  end

  test "should show exchange_product_price_log" do
    get exchange_product_price_log_url(@exchange_product_price_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_exchange_product_price_log_url(@exchange_product_price_log)
    assert_response :success
  end

  test "should update exchange_product_price_log" do
    patch exchange_product_price_log_url(@exchange_product_price_log), params: { exchange_product_price_log: { active: @exchange_product_price_log.active, dealer_id: @exchange_product_price_log.dealer_id, dealer_type: @exchange_product_price_log.dealer_type, exchange_product_id: @exchange_product_price_log.exchange_product_id, price: @exchange_product_price_log.price, time: @exchange_product_price_log.time } }
    assert_redirected_to exchange_product_price_log_url(@exchange_product_price_log)
  end

  test "should destroy exchange_product_price_log" do
    assert_difference('ExchangeProductPriceLog.count', -1) do
      delete exchange_product_price_log_url(@exchange_product_price_log)
    end

    assert_redirected_to exchange_product_price_logs_url
  end
end
