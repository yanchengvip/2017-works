require 'test_helper'

class Manage::GrantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manage_grant = manage_grants(:one)
  end

  test "should get index" do
    get manage_grants_url
    assert_response :success
  end

  test "should get new" do
    get new_manage_grant_url
    assert_response :success
  end

  test "should create manage_grant" do
    assert_difference('Manage::Grant.count') do
      post manage_grants_url, params: { manage_grant: {  } }
    end

    assert_redirected_to manage_grant_url(Manage::Grant.last)
  end

  test "should show manage_grant" do
    get manage_grant_url(@manage_grant)
    assert_response :success
  end

  test "should get edit" do
    get edit_manage_grant_url(@manage_grant)
    assert_response :success
  end

  test "should update manage_grant" do
    patch manage_grant_url(@manage_grant), params: { manage_grant: {  } }
    assert_redirected_to manage_grant_url(@manage_grant)
  end

  test "should destroy manage_grant" do
    assert_difference('Manage::Grant.count', -1) do
      delete manage_grant_url(@manage_grant)
    end

    assert_redirected_to manage_grants_url
  end
end
