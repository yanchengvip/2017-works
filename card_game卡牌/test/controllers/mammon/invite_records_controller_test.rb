require 'test_helper'

class Mammon::InviteRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mammon_invite_record = mammon_invite_records(:one)
  end

  test "should get index" do
    get mammon_invite_records_url
    assert_response :success
  end

  test "should get new" do
    get new_mammon_invite_record_url
    assert_response :success
  end

  test "should create mammon_invite_record" do
    assert_difference('Mammon::InviteRecord.count') do
      post mammon_invite_records_url, params: { mammon_invite_record: { user_id: @mammon_invite_record.user_id } }
    end

    assert_redirected_to mammon_invite_record_url(Mammon::InviteRecord.last)
  end

  test "should show mammon_invite_record" do
    get mammon_invite_record_url(@mammon_invite_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_mammon_invite_record_url(@mammon_invite_record)
    assert_response :success
  end

  test "should update mammon_invite_record" do
    patch mammon_invite_record_url(@mammon_invite_record), params: { mammon_invite_record: { user_id: @mammon_invite_record.user_id } }
    assert_redirected_to mammon_invite_record_url(@mammon_invite_record)
  end

  test "should destroy mammon_invite_record" do
    assert_difference('Mammon::InviteRecord.count', -1) do
      delete mammon_invite_record_url(@mammon_invite_record)
    end

    assert_redirected_to mammon_invite_records_url
  end
end
