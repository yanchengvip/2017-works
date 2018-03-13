class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string :var, default: '', comment: '配置的key'
      t.string :value, default: '', comment: 'var对应的配置值'
      t.text :memo, comment: '备注说明'

      t.timestamps
    end
  end
end
