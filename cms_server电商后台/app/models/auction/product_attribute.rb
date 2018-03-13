class Auction::ProductAttribute < ApplicationRecord
  self.table_name = :auction_attributes
  has_many :values
  belongs_to :editor, class_name: 'Manage::Editor', foreign_key: 'editor_id'

  INPUT_TYPE = {0 => '下拉选择框', 1 => '输入框'}
end
