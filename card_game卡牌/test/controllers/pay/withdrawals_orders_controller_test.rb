require 'test_helper'

class Pay::WithdrawalsOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pay_withdrawals_order = pay_withdrawals_orders(:one)
  end

  test "should get index" do
    get pay_withdrawals_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_pay_withdrawals_order_url
    assert_response :success
  end

  test "should create pay_withdrawals_order" do
    assert_difference('Pay::WithdrawalsOrder.count') do
      post pay_withdrawals_orders_url, params: { pay_withdrawals_order: { admin_id: @pay_withdrawals_order.admin_id, amount: @pay_withdrawals_order.amount, amount: @pay_withdrawals_order.amount, content: @pay_withdrawals_order.content, identifier: @pay_withdrawals_order.identifier, order_id: @pay_withdrawals_order.order_id, pay_date: @pay_withdrawals_order.pay_date, remark: @pay_withdrawals_order.remark, status: @pay_withdrawals_order.status, user_id: @pay_withdrawals_order.user_id } }
    end

    assert_redirected_to pay_withdrawals_order_url(Pay::WithdrawalsOrder.last)
  end

  test "should show pay_withdrawals_order" do
    get pay_withdrawals_order_url(@pay_withdrawals_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_pay_withdrawals_order_url(@pay_withdrawals_order)
    assert_response :success
  end

  test "should update pay_withdrawals_order" do
    patch pay_withdrawals_order_url(@pay_withdrawals_order), params: { pay_withdrawals_order: { admin_id: @pay_withdrawals_order.admin_id, amount: @pay_withdrawals_order.amount, amount: @pay_withdrawals_order.amount, content: @pay_withdrawals_order.content, identifier: @pay_withdrawals_order.identifier, order_id: @pay_withdrawals_order.order_id, pay_date: @pay_withdrawals_order.pay_date, remark: @pay_withdrawals_order.remark, status: @pay_withdrawals_order.status, user_id: @pay_withdrawals_order.user_id } }
    assert_redirected_to pay_withdrawals_order_url(@pay_withdrawals_order)
  end

  test "should destroy pay_withdrawals_order" do
    assert_difference('Pay::WithdrawalsOrder.count', -1) do
      delete pay_withdrawals_order_url(@pay_withdrawals_order)
    end

    assert_redirected_to pay_withdrawals_orders_url
  end
end
