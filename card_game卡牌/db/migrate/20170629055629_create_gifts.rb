class CreateGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :gifts do |t|
      t.string :name, comment: '礼物名称'
      # t.integer :gift_type, default: 0, comment: '礼物类型 1:注册赠送'
      t.boolean :status, default: true, comment: '状态 0:禁用 1:启用'
      t.boolean :delete_flag, default: false, comment: '删除标志 0:未删除 1:已删除，默认0'
      t.string :operator

      t.timestamps
    end
  end
end
