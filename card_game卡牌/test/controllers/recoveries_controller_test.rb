require 'test_helper'

class RecoveriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recovery = recoveries(:one)
  end

  test "should get index" do
    get recoveries_url
    assert_response :success
  end

  test "should get new" do
    get new_recovery_url
    assert_response :success
  end

  test "should create recovery" do
    assert_difference('Recovery.count') do
      post recoveries_url, params: { recovery: { actual_cost: @recovery.actual_cost, admin_id: @recovery.admin_id, chest_prize_id: @recovery.chest_prize_id, delete_flag: @recovery.delete_flag, is_rule: @recovery.is_rule, recovery_id: @recovery.recovery_id, time_begin: @recovery.time_begin, time_end: @recovery.time_end, total_cost: @recovery.total_cost, total_count: @recovery.total_count } }
    end

    assert_redirected_to recovery_url(Recovery.last)
  end

  test "should show recovery" do
    get recovery_url(@recovery)
    assert_response :success
  end

  test "should get edit" do
    get edit_recovery_url(@recovery)
    assert_response :success
  end

  test "should update recovery" do
    patch recovery_url(@recovery), params: { recovery: { actual_cost: @recovery.actual_cost, admin_id: @recovery.admin_id, chest_prize_id: @recovery.chest_prize_id, delete_flag: @recovery.delete_flag, is_rule: @recovery.is_rule, recovery_id: @recovery.recovery_id, time_begin: @recovery.time_begin, time_end: @recovery.time_end, total_cost: @recovery.total_cost, total_count: @recovery.total_count } }
    assert_redirected_to recovery_url(@recovery)
  end

  test "should destroy recovery" do
    assert_difference('Recovery.count', -1) do
      delete recovery_url(@recovery)
    end

    assert_redirected_to recoveries_url
  end
end
