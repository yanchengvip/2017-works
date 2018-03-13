class CreatePromotionRedPackageItems < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_red_package_items, comment: '用户红包明细' do |t|
      t.integer :status, default: 0, comment: '默认0:启用，1:禁用'
      t.string :user_id, default: '', comment: '用户id'
      t.integer :red_package_id, default: 0, comment: '红包id'
      t.decimal :amount, precision: 16, scale: 2, comment: '金额'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
    add_index :promotion_red_package_items, :user_id
  end
end
