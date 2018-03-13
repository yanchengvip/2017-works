class CreateMt4Trades < ActiveRecord::Migration[5.1]
  def change
    create_table :mt4_trades, comment: '真实交易' do |t|
      t.integer :account_id, default: 0, comment: 'AccountID'
      t.string :mt4_account, comment: '下单用户的mt4账户'
      t.string :trader_mt4_account, comment: '被跟随交易员MT4账号'
      t.string :identifier, comment: '订单号'
      t.string :symbol, comment: '交易品种'
      t.integer :cmd, default: 0, comment: '0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop'
      t.integer :volume, default: 1, comment: '交易量1=0.01手'
      t.datetime :expiration, comment: '挂单过期时间'
      t.datetime :open_time, comment: '开仓时间'
      t.decimal :price, precision: 16, scale: 5, comment: '根据cmd类型表示价格，例如cmd=2,price为挂单买入价格'
      t.decimal :open_price, precision: 16, scale: 5, comment: '开仓价格'
      t.datetime :close_time, default: '1970-01-01 00:00:00', comment: '平仓时间;时间="1970-01-01 00:00:00"为在仓单，反之则为平仓单'
      t.decimal :close_price, precision: 16, scale: 5, comment: '平仓价格'
      t.decimal :sl, precision: 16, scale: 5, comment: '止损价格'
      t.decimal :tp, precision: 16, scale: 5, comment: '止盈价格'
      t.decimal :commission, precision: 16, scale: 5, comment: '订单佣金'
      t.decimal :commission_agent, precision: 16, scale: 5, comment: '代理佣金'
      t.decimal :taxes, precision: 16, scale: 5, comment: '利息'
      t.decimal :profit, precision: 16, scale: 5, comment: '盈亏金额'
      t.decimal :margin, precision: 16, scale: 2, comment: '订单保证金'
      t.integer :dealer_id, default: 0, comment: '券商ID'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
    add_index :mt4_trades, [:account_id, :close_time, :dealer_id], name: 'account_dealer_index'
    add_index :mt4_trades, :close_time
  end
end
