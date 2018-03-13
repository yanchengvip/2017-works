class AddBeginTimeLimitToGameTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :game_types, :begin_time_limit, :boolean, default: false, comment: '是否限制开赛时间，默认 0:无限制，1:有限制'
    add_column :game_types, :begin_time, :time, comment: '开赛时间开始'
    add_column :game_types, :end_time, :time, comment: '开赛时间结束'
  end
end
