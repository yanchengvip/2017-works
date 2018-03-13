require 'test_helper'

class Core::ConnectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_connection = core_connections(:one)
  end

  test "should get index" do
    get core_connections_url
    assert_response :success
  end

  test "should get new" do
    get new_core_connection_url
    assert_response :success
  end

  test "should create core_connection" do
    assert_difference('Core::Connection.count') do
      post core_connections_url, params: { core_connection: {  } }
    end

    assert_redirected_to core_connection_url(Core::Connection.last)
  end

  test "should show core_connection" do
    get core_connection_url(@core_connection)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_connection_url(@core_connection)
    assert_response :success
  end

  test "should update core_connection" do
    patch core_connection_url(@core_connection), params: { core_connection: {  } }
    assert_redirected_to core_connection_url(@core_connection)
  end

  test "should destroy core_connection" do
    assert_difference('Core::Connection.count', -1) do
      delete core_connection_url(@core_connection)
    end

    assert_redirected_to core_connections_url
  end
end
