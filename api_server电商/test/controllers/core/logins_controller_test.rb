require 'test_helper'

class Core::LoginsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_login = core_logins(:one)
  end

  test "should get index" do
    get core_logins_url
    assert_response :success
  end

  test "should get new" do
    get new_core_login_url
    assert_response :success
  end

  test "should create core_login" do
    assert_difference('Core::Login.count') do
      post core_logins_url, params: { core_login: {  } }
    end

    assert_redirected_to core_login_url(Core::Login.last)
  end

  test "should show core_login" do
    get core_login_url(@core_login)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_login_url(@core_login)
    assert_response :success
  end

  test "should update core_login" do
    patch core_login_url(@core_login), params: { core_login: {  } }
    assert_redirected_to core_login_url(@core_login)
  end

  test "should destroy core_login" do
    assert_difference('Core::Login.count', -1) do
      delete core_login_url(@core_login)
    end

    assert_redirected_to core_logins_url
  end
end
