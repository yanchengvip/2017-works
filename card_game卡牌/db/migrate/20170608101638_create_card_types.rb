class CreateCardTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :card_types do |t|
      t.string :name, comment: '礼包分类名称'
      t.text :remark, comment: '分类介绍'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'

      t.timestamps
    end
  end
end
