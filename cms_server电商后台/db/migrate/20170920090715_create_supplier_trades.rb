class CreateSupplierTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_trades, comment: "供应商拆单" do |t|
      t.integer :auction_trade_id, comment: "商城订单ID"
      t.integer :provider_id, comment: "供应商ID"
      t.string :status, comment: "订单状态", default: ""
      t.decimal :price, precision: 16, scale: 2, comment: "市场总价-划线价"
      t.decimal :payment_price, precision: 16, scale: 2, comment: "支付价格"
      t.decimal :tax_price, precision: 16, scale: 2, comment: "税费", default: 0
      t.boolean :active, comment: "软删", default: true
      t.string :delivery_service, comment: "快递服务商"
      t.string :delivery_identifier, comment: "快递单号"
      t.datetime :ship_at, comment: "发货时间"
      t.string :remark, comment: "备注"
      t.string :delivery_phone, comment: "收货地址"
      t.decimal :balance_price, precision: 16, scale: 2, comment: "优众卡支付金额", default: 0
      t.datetime :finish_at, comment: "订单完成时间"

      t.timestamps
    end
  end
end
