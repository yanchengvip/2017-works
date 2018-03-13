class UnitTest < ActiveSupport::TestCase

  test "unit list detail detail_ids" do
    #退货
    # params = { supplier_trade_id: params[:supplier_trade_id], id: params[:id], return_name: params[:return_name], return_phone: params[:return_phone], return_province: params[:return_province], return_city: params[:return_city], return_branch: params[:return_branch], return_account: params[:return_account], user_id: Setting.test["user_id"]}
    # list_data = Auction::Unit.return(params)
    # assert_equal list_data["comm"]["code"], "200", "退货：params:#{params}\r\n response: #{list_data}"

    #退货信息
    # params = {unit_id: 1}
    # return_detail = Auction::Unit.return_detail(params)
    # assert_equal detail_data["comm"]["code"], "200", "成功：params:#{params}\r\n response: #{return_detail}"

  end
end
