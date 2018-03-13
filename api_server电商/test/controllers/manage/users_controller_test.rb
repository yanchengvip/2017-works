require 'test_helper'

class Manage::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manage_user = manage_users(:one)
  end

  test "should get index" do
    get manage_users_url
    assert_response :success
  end

  test "should get new" do
    get new_manage_user_url
    assert_response :success
  end

  test "should create manage_user" do
    assert_difference('Manage::User.count') do
      post manage_users_url, params: { manage_user: {  } }
    end

    assert_redirected_to manage_user_url(Manage::User.last)
  end

  test "should show manage_user" do
    get manage_user_url(@manage_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_manage_user_url(@manage_user)
    assert_response :success
  end

  test "should update manage_user" do
    patch manage_user_url(@manage_user), params: { manage_user: {  } }
    assert_redirected_to manage_user_url(@manage_user)
  end

  test "should destroy manage_user" do
    assert_difference('Manage::User.count', -1) do
      delete manage_user_url(@manage_user)
    end

    assert_redirected_to manage_users_url
  end
end
