require 'test_helper'

class Pay::CmbSignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pay_cmb_sign = pay_cmb_signs(:one)
  end

  test "should get index" do
    get pay_cmb_signs_url
    assert_response :success
  end

  test "should get new" do
    get new_pay_cmb_sign_url
    assert_response :success
  end

  test "should create pay_cmb_sign" do
    assert_difference('Pay::CmbSign.count') do
      post pay_cmb_signs_url, params: { pay_cmb_sign: {  } }
    end

    assert_redirected_to pay_cmb_sign_url(Pay::CmbSign.last)
  end

  test "should show pay_cmb_sign" do
    get pay_cmb_sign_url(@pay_cmb_sign)
    assert_response :success
  end

  test "should get edit" do
    get edit_pay_cmb_sign_url(@pay_cmb_sign)
    assert_response :success
  end

  test "should update pay_cmb_sign" do
    patch pay_cmb_sign_url(@pay_cmb_sign), params: { pay_cmb_sign: {  } }
    assert_redirected_to pay_cmb_sign_url(@pay_cmb_sign)
  end

  test "should destroy pay_cmb_sign" do
    assert_difference('Pay::CmbSign.count', -1) do
      delete pay_cmb_sign_url(@pay_cmb_sign)
    end

    assert_redirected_to pay_cmb_signs_url
  end
end
