class AddSortToSelfGameRules < ActiveRecord::Migration[5.0]
  def change
    add_column :self_game_rules, :sort, :integer, default: 0, comment: '排序'
  end
end
