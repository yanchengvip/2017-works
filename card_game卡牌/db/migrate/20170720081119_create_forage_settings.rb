class CreateForageSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :forage_settings do |t|
      t.integer :base_forage, default: 0, comment: '进入战场时用户基础粮草（两）'
      t.integer :turn_second, default: 0, comment: '用户每轮每X秒增长粮草'
      t.integer :turn_forage_incr, default: 0, comment: '用户每轮每X秒增长粮草数量'
      t.integer :last_turn_second, default: 0, comment: '最后一轮最后X秒狂暴增长'
      t.integer :last_turn_per_second, default: 0, comment: '最后一轮狂暴时间内每X秒增长粮草'
      t.integer :last_turn_forage_incr, default: 0, comment: '最后一轮狂暴时间内每X秒增长粮草数量'
      t.integer :max_forage, default: 0, comment: '用户每场战役粮草值上限'

      t.timestamps
    end
  end
end
