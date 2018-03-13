class CreateExtremeChestItems < ActiveRecord::Migration[5.0]
  def change
    create_table :extreme_chest_items do |t|
      t.integer :extreme_chest_id, comment: '至尊宝箱id'
      t.integer :gift_type, default: 0, comment: '赠品类型 1:计谋，2:入场券'
      t.string :gift_range, comment: '赠品范围，计谋编码或入场券'
      t.integer :gift_count, default: 0, comment: '赠品份数'
      t.boolean :delete_flag, default: 0, comment: '删除标志 0：未删除，1:已删除'

      t.timestamps
    end
  end
end
