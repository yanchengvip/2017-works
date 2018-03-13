class AddBoutMaxPersonNumber < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_rules,:max_person_number,:integer,default: 10,comment: '最大报名人数'
    add_column :battle_rules_copies,:max_person_number,:integer,default: 10,comment: '最大报名人数'
  end
end
