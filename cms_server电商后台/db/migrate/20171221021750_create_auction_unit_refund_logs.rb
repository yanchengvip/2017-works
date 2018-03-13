class CreateAuctionUnitRefundLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_unit_refund_logs,comment: '单个商品退货审核记录表' do |t|
      t.integer :unit_id, default: 0, comment: 'units表ID'
      t.integer :editor_id, default: 0, comment: '审核者管理员ID,如果为0则是用户创建'
      t.string :status, comment: 'audit=待审核,receive=待收货,transfer=待退款,complete=完成,cancel=取消,freezed=冻结'
      t.text :remark, comment: '备注'
      t.boolean :active, comment: "软删", default: true
      t.timestamps
    end
    add_index :auction_unit_refund_logs, :unit_id
  end
end

