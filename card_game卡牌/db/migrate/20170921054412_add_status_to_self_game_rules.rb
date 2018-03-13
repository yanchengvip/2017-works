class AddStatusToSelfGameRules < ActiveRecord::Migration[5.0]
  def change
    add_column :self_game_rules, :status, :boolean, default: false, comment: '启用状态，默认0:停用， 1:启用'
  end
end
