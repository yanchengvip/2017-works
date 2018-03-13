class UserTest < ActiveSupport::TestCase

  test "user list detail detail_ids" do
    #用户详细信息
    params = {id: Setting.test["user_id"]}
    user_data = Auction::User.users(params)
    assert_equal user_data["comm"]["code"], "200", "用户信息：params:#{params}\r\n response: #{user_data}"
  end
end
