class AddLuckyCodeToMallOrders < ActiveRecord::Migration[5.0]
  def change
    begin
      add_column :mall_orders, :lucky_code, :string, default: '', comment: '幸运号码，如果是兑奖阁订单则不用填'
    rescue Exception => e
      p e
    end
  end
end
