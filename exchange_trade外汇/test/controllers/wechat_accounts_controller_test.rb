require 'test_helper'

class WechatAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wechat_account = wechat_accounts(:one)
  end

  test "should get index" do
    get wechat_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_wechat_account_url
    assert_response :success
  end

  test "should create wechat_account" do
    assert_difference('WechatAccount.count') do
      post wechat_accounts_url, params: { wechat_account: { active: @wechat_account.active, city: @wechat_account.city, country: @wechat_account.country, headimgurl: @wechat_account.headimgurl, nickname: @wechat_account.nickname, openid: @wechat_account.openid, province: @wechat_account.province, request_ip: @wechat_account.request_ip, sex: @wechat_account.sex, unionid: @wechat_account.unionid, user_id: @wechat_account.user_id } }
    end

    assert_redirected_to wechat_account_url(WechatAccount.last)
  end

  test "should show wechat_account" do
    get wechat_account_url(@wechat_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_wechat_account_url(@wechat_account)
    assert_response :success
  end

  test "should update wechat_account" do
    patch wechat_account_url(@wechat_account), params: { wechat_account: { active: @wechat_account.active, city: @wechat_account.city, country: @wechat_account.country, headimgurl: @wechat_account.headimgurl, nickname: @wechat_account.nickname, openid: @wechat_account.openid, province: @wechat_account.province, request_ip: @wechat_account.request_ip, sex: @wechat_account.sex, unionid: @wechat_account.unionid, user_id: @wechat_account.user_id } }
    assert_redirected_to wechat_account_url(@wechat_account)
  end

  test "should destroy wechat_account" do
    assert_difference('WechatAccount.count', -1) do
      delete wechat_account_url(@wechat_account)
    end

    assert_redirected_to wechat_accounts_url
  end
end
