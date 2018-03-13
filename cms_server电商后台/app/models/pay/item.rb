class Pay::Item < ApplicationRecord
  belongs_to :editor, class_name: 'Manage::Editor', foreign_key: 'user_id'
  PAYTYPE = {0 => "无", 1 => "支付宝支付", 2 => "微信支付", 3 => "货到付款", 4 => "paypal"}
end
