class AccountTest < ActiveSupport::TestCase

  test "account list detail detail_ids" do
    #注册账号
    # params = {phone: params[:phone], password: params[:password], password_confirmation: params[:password_confirmation], client: params[:client], message_code: params[:message_code]}
    # account_data = Core::Account.insert(params)
    # assert_equal list_data["comm"]["code"], "200", "注册账号成功：params:#{params}\r\n response: #{account_data}"

    #修改
    # params = {old_password: params[:old_password], password: params[:password]}
    # update_data = Core::Account.updateaccount(params)
    # assert_equal list_data["comm"]["code"], "200", "修改账号成功：params:#{params}\r\n response: #{update_data}"

    # #忘记密码
    # params = {phone: params[:phone], password: params[:password], password_confirmation: params[:password_confirmation], message_code: params[:message_code]}
    # forget_data = Core::Account.forgetPassword(params)
    # assert_equal list_data["comm"]["code"], "200", "忘记密码成功：params:#{params}\r\n response: #{forget_data}"
  end
end
