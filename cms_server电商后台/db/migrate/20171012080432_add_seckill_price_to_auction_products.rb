class AddSeckillPriceToAuctionProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_products, :seckill_price, :decimal, precision: 16, scale: 2, comment: "秒杀价"
    add_column :auction_products, :seckill_begin_time, :string, comment: "秒杀开始时间"
    add_column :auction_products, :seckill_end_time, :string, comment: "秒杀结束时间"
  end
end
