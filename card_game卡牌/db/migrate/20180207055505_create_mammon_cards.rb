class CreateMammonCards < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_cards, comment: "技能牌" do |t|
      t.string :name, comment: "名字"
      t.string :num, comment: "编号"
      t.integer :card_type, comment: "类型"
      t.decimal :percent, precision: 15, scale: 2, comment: "抽取概率", default: 0
      t.decimal :effect_percent, precision: 15, scale: 2, comment: "获取百分比", default: 0
      t.integer :effect_times, comment: "生效次数"
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
