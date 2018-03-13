class ChangeColumnRoundBloodGluttonSettings < ActiveRecord::Migration[5.0]
  def change
    change_column :glutton_settings, :round_blood, :string, default: '', comment: '饕餮出现后，每轮的血量，逗号隔开如：1,2,3,4,5,6'
  end
end
