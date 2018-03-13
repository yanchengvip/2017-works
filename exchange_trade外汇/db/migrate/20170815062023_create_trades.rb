class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades, comment: '交易表' do |t|
      t.integer :account_id, default: 0, comment: '账号ID'
      t.string :mt4_account, comment: 'MT4账号'
      t.string :order_code, comment: '订单号'
      t.string :symbol, comment: '交易品种  字母表示'
      t.integer :digits, default: 0, comment: '交易品种 数字表示'
      t.integer :cmd, comment: '0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop, 6 = 入金 / 出金, 7 = 信用'
      t.integer :volume, default: 0, comment: '手数'
      t.datetime :open_time, comment: '开仓时间'
      t.decimal :open_price, default: 0, precision: 16, scale: 6, comment: '开仓价格'
      t.decimal :sl, default: 0, precision: 16, scale: 6, comment: '止亏'
      t.decimal :tp, default: 0, precision: 16, scale: 6, comment: '止盈'
      t.datetime :close_time, default: '1970-01-01 00:00:00', comment: '平仓时间;时间="1970-01-01 00:00:00"为在仓单，反之则为平仓单'
      t.decimal :close_price, default: 0, precision: 16, scale: 6, comment: '平仓价格'
      t.decimal :commission, default: 0, precision: 16, scale: 6, comment: '佣金'
      t.decimal :profit, default: 0, precision: 16, scale: 6, comment: '利润'
      t.integer :source, default: 0, comment: '订单来源 1：跟单，2：跟人/策略,3:自主交易'
      t.integer :dealer_id, default: 0, comment: '券商表dealers表ID'
      t.integer :dealer_type, default: 0, comment: '关联券商类型dealer_type'
      t.string :tactic_flag, comment: '策略唯一标识符'
      t.integer :trade_id, default: 0, comment: '被跟随订单的trades表的ID'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :trades, [:account_id, :dealer_id], name: 'account_dealer_index'
    add_index :trades, :mt4_account
    add_index :trades, :tactic_flag
    add_index :trades, :close_time
    add_index :trades, :order_code, :unique => true
  end
end
