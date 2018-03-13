class CreateChestRecordPays < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_record_pays do |t|
      t.integer :user_id, comment: '用户ID'
      t.string :out_trade_no, comment: '商户订单号'
      t.integer :chest_record_id, comment: 'chest_records ID'
      t.integer :pay_type, default: 0, comment: '0:无,1:支付宝支付,2:微信支付'
      t.string :trade_no, comment: '支付宝交易凭证号/微信支付订单号'
      t.integer :trade_status, default: 1, comment: '交易状态,1:交易支付成功'
      t.string :notify_id, comment: '通知校验ID,发送同一条异步通知时notify_id是不变的'
      t.datetime :notify_time, comment: '支付成功通知时间'
      t.datetime :gmt_payment, comment: '交易付款时间'
      t.string :buyer_id, comment: '买家支付宝用户号/微信用户openid'
      t.string :seller_id, comment: '卖家支付宝用户号/微信商户号'
      t.decimal :total_amount, precision: 12, scale: 2, default: 0, comment: '订单金额'
      t.decimal :receipt_amount, precision: 12, scale: 2, default: 0, comment: '商家在交易中实际收到的款项'
      t.decimal :buyer_pay_amount, precision: 12, scale: 2, default: 0, comment: '用户在交易中支付的金额'
      t.text :content, comment: '支付详情'

      t.timestamps
    end
  end
end
