class CreateGiveCopies < ActiveRecord::Migration[5.0]
  def change
    create_table :copies do |t|
      t.string :title, comment: '文案标题'
      t.text :content, comment: '文案内容'
      t.string :thumbnail, comment: '文案图片'
      t.integer :copy_type, default: 0, comment: '文案类型 1:赠送卡牌的文案'
      t.boolean :status, default: true, comment: '状态 0:禁用，1:启用'
      t.boolean :delete_flag, default: false, comment: '删除状态 0:未删除，1:已删除'

      t.timestamps
    end

    add_index :copies, :copy_type
  end
end
