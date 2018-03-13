class ReportTest < ActiveSupport::TestCase

  test "report list detail detail_ids" do
    #反馈
    params = { reason: "test", description: "description", url: "http://127.0.0.1", user_id: Setting.test["user_id"]}

    data = Core::Report.insert(params)
    assert_equal data["comm"]["code"], "200", "反馈成功：params:#{params}\r\n response: #{data}"

  end
end
