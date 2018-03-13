require 'test_helper'

class MedalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medal = medals(:one)
  end

  test "should get index" do
    get medals_url
    assert_response :success
  end

  test "should get new" do
    get new_medal_url
    assert_response :success
  end

  test "should create medal" do
    assert_difference('Medal.count') do
      post medals_url, params: { medal: { active: @medal.active, condition: @medal.condition, content: @medal.content, enable: @medal.enable, image: @medal.image, medal_type: @medal.medal_type, name: @medal.name } }
    end

    assert_redirected_to medal_url(Medal.last)
  end

  test "should show medal" do
    get medal_url(@medal)
    assert_response :success
  end

  test "should get edit" do
    get edit_medal_url(@medal)
    assert_response :success
  end

  test "should update medal" do
    patch medal_url(@medal), params: { medal: { active: @medal.active, condition: @medal.condition, content: @medal.content, enable: @medal.enable, image: @medal.image, medal_type: @medal.medal_type, name: @medal.name } }
    assert_redirected_to medal_url(@medal)
  end

  test "should destroy medal" do
    assert_difference('Medal.count', -1) do
      delete medal_url(@medal)
    end

    assert_redirected_to medals_url
  end
end
