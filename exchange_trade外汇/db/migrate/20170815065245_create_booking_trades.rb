class CreateBookingTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_trades, comment: '挂单表' do |t|
      t.integer :account_id, default: 0, comment: '账号ID'
      t.integer :trade_type, default: 0, comment: '0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop, 6 = 入金 / 出金, 7 = 信用, 8 = 平仓(卖出)'
      t.string :mt4_account, comment: 'MT4账号'
      t.string :symbol, comment: '交易品种  字母表示'
      t.integer :digits, default: 0, comment: '交易品种 数字表示'
      t.integer :volume, default: 0, comment: '手数'
      t.decimal :deal_price, default: 0, precision: 16, scale: 6, comment: '成交价格'
      t.decimal :booking_price, default: 0, precision: 16, scale: 6, comment: '挂单价格'
      t.decimal :sl, default: 0, precision: 16, scale: 6, comment: '止亏'
      t.decimal :tp, default: 0, precision: 16, scale: 6, comment: '止盈'
      t.integer :source, default: 0, comment: '订单来源 1：跟单，2：跟人/策略,3:自主交易'
      t.integer :dealer_id, default: 0, comment: '券商表dealers表ID'
      t.integer :dealer_type, default: 0, comment: '关联券商类型dealer_type'
      t.string :tactic_flag, comment: '策略唯一标识符'
      t.integer :trade_id, default: 0, comment: '跟单的交易表的ID'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :booking_trades, [:account_id, :dealer_id], name: 'b_account_dealer_index'
    add_index :booking_trades, :mt4_account
    add_index :booking_trades, :trade_id
  end
end
