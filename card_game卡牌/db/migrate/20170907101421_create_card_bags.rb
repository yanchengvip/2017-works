class CreateCardBags < ActiveRecord::Migration[5.0]
  def change
    create_table :card_bags, comment: '卡包表' do |t|
      t.string :name, default: '', comment: '卡包名称'

      t.boolean :delete_flag, default: false, comment: '删除标志，默认为0 1:已删除，0:为删除'

      t.timestamps
    end

    add_index :card_bags, :name
  end
end
