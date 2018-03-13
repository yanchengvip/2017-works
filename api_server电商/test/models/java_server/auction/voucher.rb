class VoucherTest < ActiveSupport::TestCase

  test "voucher list detail detail_ids" do
    #优惠券列表
    params = {userId: Setting.test["user_id"], pageNo: 1, pageSize: 10}
    data = Auction::Voucher.vouchers(params)
    assert_equal data["comm"]["code"], "200", "优惠券列表：params:#{params}\r\n response: #{data}"
  end
end
