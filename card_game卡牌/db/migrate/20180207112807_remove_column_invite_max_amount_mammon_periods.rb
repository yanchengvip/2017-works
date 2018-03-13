class RemoveColumnInviteMaxAmountMammonPeriods < ActiveRecord::Migration[5.0]
  def change
    remove_column :mammon_periods, :invite_max_amount
  end
end
