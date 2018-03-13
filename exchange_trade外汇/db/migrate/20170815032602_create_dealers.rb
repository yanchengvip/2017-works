class CreateDealers < ActiveRecord::Migration[5.1]
  def change
    create_table :dealers, comment: '券商表' do |t|
      t.string :name, comment: '交易商名称'
      t.integer :dealer_type, default: 0, comment: '券商类型;0:无,1:模拟盘账户,2:wisdom账户'
      t.integer :status, default: 1, comment: '1:启用,2：禁用'
      t.string :content, comment: '描述'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :dealers, :name
    add_index :dealers, :dealer_type
  end
end
