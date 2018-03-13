class CreateTactics < ActiveRecord::Migration[5.1]
  def change
    create_table :tactics, comment: '策略表' do |t|
      t.string :name, comment: '策略名称'
      t.text :detail, comment: '策略详情'
      t.decimal :sl,default: 0, precision: 16, scale: 6, comment: '止亏'
      t.decimal :tp,default: 0, precision: 16, scale: 6, comment: '止盈'
      t.decimal :commission, default: 0, precision: 16, scale: 6, comment: '佣金'
      t.string :tactic_flag, comment: '策略唯一标识符'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :tactics,:name
    add_index :tactics,:tactic_flag,unique: true
  end
end
