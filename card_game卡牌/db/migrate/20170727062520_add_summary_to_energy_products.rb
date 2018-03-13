class AddSummaryToEnergyProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :energy_products, :summary, :string, default: '', comment: '商品描述'
  end
end
