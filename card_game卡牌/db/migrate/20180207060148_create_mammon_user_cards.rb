class CreateMammonUserCards < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_user_cards, comment: "用户技能牌" do |t|
      t.integer :user_id, comment: "用户id"
      t.integer :card_id, comment: "卡牌id"
      t.integer :period_id, comment: "财神期号ID"
      t.integer :count, comment: "数量"
      t.integer :status, comment: "是否有效0:有效，1:无效", default: 0
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
