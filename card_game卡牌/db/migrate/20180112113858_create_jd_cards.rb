class CreateJdCards < ActiveRecord::Migration[5.0]
  def change
    create_table :jd_cards, comment: '京东卡' do |t|
      t.string :code, default: '', comment: '卡号'
      t.string :password, default: '', comment: '卡密码'
      t.decimal :price, precision: 10, scale: 2, comment: '金额'
      t.integer :chest_record_id, comment: '抽奖记录id'


      t.timestamps
    end

    add_index :jd_cards, :chest_record_id
  end
end
