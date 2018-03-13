class CreateDealers < ActiveRecord::Migration[5.1]
  def change
    create_table :dealers do |t|
      t.string :name, comment: '券商名称'
      t.integer :dealer_type, default: 0, comment: '券商类型：1:虚拟券商，2：约汇网券商'
      t.integer :status, comment: '1:启用,2：禁用'
      t.text :desc, comment: '简介'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
