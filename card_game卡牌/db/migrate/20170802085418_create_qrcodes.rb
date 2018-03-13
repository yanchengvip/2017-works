class CreateQrcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :qrcodes do |t|
      t.string :name,comment: '渠道名称'
      t.integer :number,default: 0,comment: '扫描二维码数量'
      t.string :desc,comment: '描述'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
