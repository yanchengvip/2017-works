require 'test_helper'

class RecoveryItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recovery_item = recovery_items(:one)
  end

  test "should get index" do
    get recovery_items_url
    assert_response :success
  end

  test "should get new" do
    get new_recovery_item_url
    assert_response :success
  end

  test "should create recovery_item" do
    assert_difference('RecoveryItem.count') do
      post recovery_items_url, params: { recovery_item: { chest_prize_id: @recovery_item.chest_prize_id, count: @recovery_item.count, delete_flag: @recovery_item.delete_flag, recovery_id: @recovery_item.recovery_id, user_id: @recovery_item.user_id } }
    end

    assert_redirected_to recovery_item_url(RecoveryItem.last)
  end

  test "should show recovery_item" do
    get recovery_item_url(@recovery_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_recovery_item_url(@recovery_item)
    assert_response :success
  end

  test "should update recovery_item" do
    patch recovery_item_url(@recovery_item), params: { recovery_item: { chest_prize_id: @recovery_item.chest_prize_id, count: @recovery_item.count, delete_flag: @recovery_item.delete_flag, recovery_id: @recovery_item.recovery_id, user_id: @recovery_item.user_id } }
    assert_redirected_to recovery_item_url(@recovery_item)
  end

  test "should destroy recovery_item" do
    assert_difference('RecoveryItem.count', -1) do
      delete recovery_item_url(@recovery_item)
    end

    assert_redirected_to recovery_items_url
  end
end
