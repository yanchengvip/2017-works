class Manage::ReportForm < ApplicationRecord
  self.table_name = 'supplier_report_forms'
  belongs_to :supplier,class_name: 'Manage::Provider',foreign_key: :provider_id
  STATUS = {0 => '未结算', 1 => '已结算'}
  scope :own, ->(provider_id) { where(provider_id: provider_id) }
end
