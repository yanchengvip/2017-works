class AddNumToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :expire_days, :integer, default: 1, comment: '战役兑换商品有效天数'
  end
end
