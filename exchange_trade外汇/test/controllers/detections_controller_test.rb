require 'test_helper'

class DetectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detection = detections(:one)
  end

  test "should get index" do
    get detections_url
    assert_response :success
  end

  test "should get new" do
    get new_detection_url
    assert_response :success
  end

  test "should create detection" do
    assert_difference('Detection.count') do
      post detections_url, params: { detection: {  } }
    end

    assert_redirected_to detection_url(Detection.last)
  end

  test "should show detection" do
    get detection_url(@detection)
    assert_response :success
  end

  test "should get edit" do
    get edit_detection_url(@detection)
    assert_response :success
  end

  test "should update detection" do
    patch detection_url(@detection), params: { detection: {  } }
    assert_redirected_to detection_url(@detection)
  end

  test "should destroy detection" do
    assert_difference('Detection.count', -1) do
      delete detection_url(@detection)
    end

    assert_redirected_to detections_url
  end
end
