class CreatePromotionRedPackageRules < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_red_package_rules, comment: '红包规则' do |t|
      t.string :name, default: '', comment: '名称'
      t.integer :status, default: 0, comment: '默认0:启用，1:禁用'
      t.integer :open_wait_time, default: 0, comment: '等待开启时长'
      t.integer :close_wait_time, default: 0, comment: '等待结束时长'
      t.decimal :total_amount, precision: 16, scale: 2, default: 0, comment: '总金额'
      t.integer :admin_id, default: 0, comment: '创建人'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
