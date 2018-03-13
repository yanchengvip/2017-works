class SessionTest < ActiveSupport::TestCase

  test "session list detail detail_ids" do

    user_id = Setting.test["user_id"]
    #登录
    params = { phone: "18518639588", password: "111111"}
    login_data = Core::Session.login(params)
    assert_equal login_data["comm"]["code"], "200", "登录成功：params:#{params}\r\n response: #{login_data}"


    #退出
    params = { id: user_id}
    logout_data = Core::Session.logout(params)
    assert_equal logout_data["comm"]["code"], "200", "退出成功：params:#{params}\r\n response: #{logout_data}"



  end
end
