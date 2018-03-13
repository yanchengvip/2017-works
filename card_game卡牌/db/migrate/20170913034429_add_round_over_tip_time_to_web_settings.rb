class AddRoundOverTipTimeToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :round_over_tip_time, :integer, default: 0, comment: '距离本轮结束还有XX秒时提示'
    add_column :web_settings, :round_over_tip_text, :string, default: '', comment: '距离本轮结束还有XX秒时提示的信息'

    add_column :web_settings, :keys_gt_text, :string, default: '', comment: '密钥百分比超过基值提示的信息'
    add_column :web_settings, :keys_lt_text, :string, default: '', comment: '密钥百分比低于基值提示的信息'
    add_column :web_settings, :winner_tip_time, :integer, default: 0, comment: '每隔XX秒，提示赛场第一名'
    add_column :web_settings, :winner_tip_text, :string, default: '', comment: '每隔XX秒，提示赛场第一名的信息'
  end
end
