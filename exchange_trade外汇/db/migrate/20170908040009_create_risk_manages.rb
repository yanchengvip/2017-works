class CreateRiskManages < ActiveRecord::Migration[5.1]
  def change
    create_table :risk_manages,comment:'风险管理' do |t|
      t.integer :risk_type, default: 0, comment: '报警类型'
      t.decimal :percent, precision: 16, scale: 6, default: 0, comment: '百分比'
      t.integer :level, default: 0, comment: '等级'
      t.integer :interval, default: 0, comment: '报警间隔'
      t.integer :number, default: 1, comment: '发送次数'
      t.datetime :start_time, comment: '发送开始时间'
      t.datetime :end_time, comment: '发送结束时间'
      t.text :context, comment: '发送内容'
      t.text :desc, comment: '备注'
      t.integer :dealer_id, default: 0, comment: '券商表dealers表ID'
      t.integer :dealer_type, default: 0, comment: '关联券商类型dealer_type'
      t.boolean :active, default: true, comment: '软删'
    end
  end
end
