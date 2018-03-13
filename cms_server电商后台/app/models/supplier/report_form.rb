class Supplier::ReportForm < ApplicationRecord
  scope :own, ->(provider_id) { where(provider_id: provider_id) }
  belongs_to :editor, :class_name => "Manage::Editor",foreign_key: 'user_id'
  STATUS = {
    0 => "未结算",
    1 => "已结算"
  }
end
