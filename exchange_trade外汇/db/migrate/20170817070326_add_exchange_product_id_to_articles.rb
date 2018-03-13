class AddExchangeProductIdToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :exchange_product_id, :integer, comment: "外汇品种id"
  end
end
