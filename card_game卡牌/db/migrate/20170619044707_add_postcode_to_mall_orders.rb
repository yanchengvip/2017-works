class AddPostcodeToMallOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :mall_orders, :postcode, :string, comment: '邮编'
  end
end
