require 'test_helper'

class Manage::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manage_role = manage_roles(:one)
  end

  test "should get index" do
    get manage_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_manage_role_url
    assert_response :success
  end

  test "should create manage_role" do
    assert_difference('Manage::Role.count') do
      post manage_roles_url, params: { manage_role: {  } }
    end

    assert_redirected_to manage_role_url(Manage::Role.last)
  end

  test "should show manage_role" do
    get manage_role_url(@manage_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_manage_role_url(@manage_role)
    assert_response :success
  end

  test "should update manage_role" do
    patch manage_role_url(@manage_role), params: { manage_role: {  } }
    assert_redirected_to manage_role_url(@manage_role)
  end

  test "should destroy manage_role" do
    assert_difference('Manage::Role.count', -1) do
      delete manage_role_url(@manage_role)
    end

    assert_redirected_to manage_roles_url
  end
end
