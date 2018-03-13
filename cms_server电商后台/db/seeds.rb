# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Supplier::ReportForm.create(provider_id: 1, date: "2017-01", trade_amount: 1000, express_amount: 200, other_fee: 100, remark: "扣款", total_amount: 700, status: 0, user_id:1)
Supplier::ReportForm.create(provider_id: 1, date: "2017-02", trade_amount: 1000, express_amount: 200, other_fee: 100, remark: "扣款", total_amount: 700, status: 0, user_id:1)
Supplier::ReportForm.create(provider_id: 1, date: "2017-03", trade_amount: 1000, express_amount: 200, other_fee: 100, remark: "扣款", total_amount: 700, status: 0, user_id:1)
Supplier::ReportForm.create(provider_id: 1, date: "2017-04", trade_amount: 1000, express_amount: 200, other_fee: 100, remark: "扣款", total_amount: 700, status: 0, user_id:1)
Supplier::ReportForm.create(provider_id: 1, date: "2017-05", trade_amount: 1000, express_amount: 200, other_fee: 100, remark: "扣款", total_amount: 700, status: 0, user_id:1)
products = Auction::Product.where("active = true and published = true").first(9)
(Date.today..Date.today+60).each do |day|
  products.each_with_index do |product, index|
    Auction::Seckill.create( product_id: product.id, discount: product.discount * 0.8, date: day, play: ((index+1).to_f / 3).ceil , active: true, user_id: 0)
  end
end
