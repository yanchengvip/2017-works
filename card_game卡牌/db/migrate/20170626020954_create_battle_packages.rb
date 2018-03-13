class CreateBattlePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_packages do |t|
      t.string :name, comment: '赠送卡牌规则名称'
      t.integer :battle_id, default: 0, comment: '战役ID'
      t.integer :package_id, default: 0, comment: '礼包ID'
      t.integer :package_num, default: 0, comment: '礼包数量'
      t.integer :micro_score, default: 0, comment: '消耗的微集分数量，用于战役中失败者的礼包'
      t.integer :bp_type, default: 0, comment: 'battle_packages类型,1:战役获胜的礼包,2:战役失败的礼包'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.text :desc, comment: '描述'
      t.timestamps
    end
  end
end
