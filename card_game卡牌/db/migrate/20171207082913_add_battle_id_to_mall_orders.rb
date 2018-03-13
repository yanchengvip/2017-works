class AddBattleIdToMallOrders < ActiveRecord::Migration[5.0]
  def change
    begin
      add_column :mall_orders, :battle_id, :integer, default: 0, comment: '对应赛场id（包括平台赛场或自建赛场），默认为0:兑奖阁订单'
    rescue Exception => e
      p e
    end
  end
end
