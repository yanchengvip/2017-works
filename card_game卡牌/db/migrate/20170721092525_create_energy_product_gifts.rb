class CreateEnergyProductGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :energy_product_gifts do |t|
      t.integer :energy_product_id, default: 0, comment: '能量商品id'
      t.integer :buy_times, default: 0, comment: '对应第多少次购买'
      t.integer :energy_count, default: 0, comment: '赠送能量的数量'
      t.string :show_text
      t.boolean :delete_flag, default: false, comment: '删除标志，1:已删除，0:未删除'

      t.timestamps
    end
  end
end
