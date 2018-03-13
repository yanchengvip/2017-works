require 'test_helper'

class Core::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_report = core_reports(:one)
  end

  test "should get index" do
    get core_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_core_report_url
    assert_response :success
  end

  test "should create core_report" do
    assert_difference('Core::Report.count') do
      post core_reports_url, params: { core_report: {  } }
    end

    assert_redirected_to core_report_url(Core::Report.last)
  end

  test "should show core_report" do
    get core_report_url(@core_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_report_url(@core_report)
    assert_response :success
  end

  test "should update core_report" do
    patch core_report_url(@core_report), params: { core_report: {  } }
    assert_redirected_to core_report_url(@core_report)
  end

  test "should destroy core_report" do
    assert_difference('Core::Report.count', -1) do
      delete core_report_url(@core_report)
    end

    assert_redirected_to core_reports_url
  end
end
