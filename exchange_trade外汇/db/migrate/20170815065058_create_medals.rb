class CreateMedals < ActiveRecord::Migration[5.1]
  def change
    create_table :medals, comment: '勋章表' do |t|
      t.string :name, comment: "勋章名称"
      t.float :condition, comment: "完成条件"
      t.integer :medal_type, comment: "类型;1:交易次数;2:盈利次数;3:复制交易次数；4:入金次数5:账户余额；6:跟随者；7:邀请好友8:交易资金"
      t.string :image, comment: '勋章图片'
      t.text :content, comment: '勋章简介'
      t.integer :enable, comment: '0:禁用2：启用'
      t.boolean :active, default: true, comment: "软删除字段"

      t.timestamps
    end

    add_index :medals,:name
  end
end
