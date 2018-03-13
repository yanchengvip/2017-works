class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name, comment: '活动名称'
      t.datetime :start_time, comment: '促销开始时间'
      t.datetime :end_time, comment: '促销结束时间'
      t.integer :rule_type, comment: '促销规则 1:满赠'
      t.decimal :amount, comment: '累计购买金额赠送'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'

      t.timestamps
    end
  end
end
