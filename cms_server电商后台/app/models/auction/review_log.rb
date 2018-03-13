class Auction::ReviewLog < ApplicationRecord
  belongs_to :table, polymorphic: true
  # belongs_to :product, class_name: 'Supplier::Product', foreign_key: 'product_id'
  belongs_to :editor, class_name: 'Manage::Editor', foreign_key: 'editor_id'
end
