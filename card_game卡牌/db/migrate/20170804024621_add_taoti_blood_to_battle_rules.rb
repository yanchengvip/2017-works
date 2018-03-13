class AddTaotiBloodToBattleRules < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_rules, :taoti_blood, :string,default: 1, comment: '饕鬄每轮的血量值,例如值为10,20，代表第一轮血量为10，第二轮20'
    add_column :battle_rules_copies, :taoti_blood, :string,default: 1, comment: '饕鬄每轮的血量值,例如值为10,20，代表第一轮血量为10，第二轮20'
  end
end
