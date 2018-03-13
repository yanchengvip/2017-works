require 'test_helper'

class Manage::EditorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manage_editor = manage_editors(:one)
  end

  test "should get index" do
    get manage_editors_url
    assert_response :success
  end

  test "should get new" do
    get new_manage_editor_url
    assert_response :success
  end

  test "should create manage_editor" do
    assert_difference('Manage::Editor.count') do
      post manage_editors_url, params: { manage_editor: {  } }
    end

    assert_redirected_to manage_editor_url(Manage::Editor.last)
  end

  test "should show manage_editor" do
    get manage_editor_url(@manage_editor)
    assert_response :success
  end

  test "should get edit" do
    get edit_manage_editor_url(@manage_editor)
    assert_response :success
  end

  test "should update manage_editor" do
    patch manage_editor_url(@manage_editor), params: { manage_editor: {  } }
    assert_redirected_to manage_editor_url(@manage_editor)
  end

  test "should destroy manage_editor" do
    assert_difference('Manage::Editor.count', -1) do
      delete manage_editor_url(@manage_editor)
    end

    assert_redirected_to manage_editors_url
  end
end
