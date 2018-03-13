class CreatePromotionRedPackages < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_red_packages, comment: '红包' do |t|
      t.integer :status, default: 0, comment: '默认0:启用，1:禁用'
      t.string :table_type, default: '', comment: '关联表model'
      t.integer :table_id, default: 0, comment: '关联表id'
      t.integer :red_package_rule_id, default: 0, comment: '红包规则表id'
      t.datetime :begin_time, comment: '开始时间'
      t.datetime :end_time, comment: '结束时间'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
    add_index :promotion_red_packages, [:table_id, :table_type]
  end
end
