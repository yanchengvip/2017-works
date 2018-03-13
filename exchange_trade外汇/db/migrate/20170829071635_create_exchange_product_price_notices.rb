class CreateExchangeProductPriceNotices < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_product_price_notices, comment: "价格变动消息通知表" do |t|
      t.integer :user_id, comment: "用户id", default: 0
      t.integer :exchange_product_id, comment: "外汇价格变化id", default: 0
      t.decimal :current_price, precision: 10, scale: 6, comment: "当前价格", default: 0
      t.decimal :up_price, precision: 10, scale: 6, comment: "上涨推送价格", default: 0
      t.decimal :down_price, precision: 10, scale: 6, comment: "下跌推送价格", default: 0
      t.datetime :up_price_end_time, comment: "上涨推送时间"
      t.datetime :down_price_end_time, comment: "下跌推送时间"
      t.boolean :active, comment: "软删除标志", default: 0
      t.boolean :up_notice, comment: "上涨推送状态", default: false
      t.boolean :down_notice, comment: "下跌推送状态", default: false
      t.integer :notice_type, comment: "推送方式 1 极光", default: 1
      t.integer :dealer_id, comment: "账户类型", default: 0

      t.timestamps
    end
  end
end
