require 'test_helper'

class ExchangeProductPriceNoticesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exchange_product_price_notice = exchange_product_price_notices(:one)
  end

  test "should get index" do
    get exchange_product_price_notices_url
    assert_response :success
  end

  test "should get new" do
    get new_exchange_product_price_notice_url
    assert_response :success
  end

  test "should create exchange_product_price_notice" do
    assert_difference('ExchangeProductPriceNotice.count') do
      post exchange_product_price_notices_url, params: { exchange_product_price_notice: { active: @exchange_product_price_notice.active, current_price: @exchange_product_price_notice.current_price, down_notice: @exchange_product_price_notice.down_notice, down_price: @exchange_product_price_notice.down_price, down_price_end_time: @exchange_product_price_notice.down_price_end_time, exchange_product_id: @exchange_product_price_notice.exchange_product_id, notice_type: @exchange_product_price_notice.notice_type, up_notice: @exchange_product_price_notice.up_notice, up_price: @exchange_product_price_notice.up_price, up_price_end_time: @exchange_product_price_notice.up_price_end_time, user_id: @exchange_product_price_notice.user_id } }
    end

    assert_redirected_to exchange_product_price_notice_url(ExchangeProductPriceNotice.last)
  end

  test "should show exchange_product_price_notice" do
    get exchange_product_price_notice_url(@exchange_product_price_notice)
    assert_response :success
  end

  test "should get edit" do
    get edit_exchange_product_price_notice_url(@exchange_product_price_notice)
    assert_response :success
  end

  test "should update exchange_product_price_notice" do
    patch exchange_product_price_notice_url(@exchange_product_price_notice), params: { exchange_product_price_notice: { active: @exchange_product_price_notice.active, current_price: @exchange_product_price_notice.current_price, down_notice: @exchange_product_price_notice.down_notice, down_price: @exchange_product_price_notice.down_price, down_price_end_time: @exchange_product_price_notice.down_price_end_time, exchange_product_id: @exchange_product_price_notice.exchange_product_id, notice_type: @exchange_product_price_notice.notice_type, up_notice: @exchange_product_price_notice.up_notice, up_price: @exchange_product_price_notice.up_price, up_price_end_time: @exchange_product_price_notice.up_price_end_time, user_id: @exchange_product_price_notice.user_id } }
    assert_redirected_to exchange_product_price_notice_url(@exchange_product_price_notice)
  end

  test "should destroy exchange_product_price_notice" do
    assert_difference('ExchangeProductPriceNotice.count', -1) do
      delete exchange_product_price_notice_url(@exchange_product_price_notice)
    end

    assert_redirected_to exchange_product_price_notices_url
  end
end
