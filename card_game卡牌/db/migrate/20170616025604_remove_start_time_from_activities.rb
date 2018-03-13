class RemoveStartTimeFromActivities < ActiveRecord::Migration[5.0]
  def up
    remove_column :activities, :start_time
    remove_column :activities, :end_time
    remove_column :activities, :rule_type
    remove_column :activities, :amount
  end
  def down
    add_column :activities, :start_time, :datetime, comment: '促销开始时间'
    add_column :activities, :end_time, :datetime, comment: '促销结束时间'
    add_column :activities, :rule_type, :integer, comment: '促销规则 1:满赠'
    add_column :activities, :amount, :decimal, precision: 10, scale: 2, comment: '累计购买金额赠送'
  end
end
