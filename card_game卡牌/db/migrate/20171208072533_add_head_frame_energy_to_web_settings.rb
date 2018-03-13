class AddHeadFrameEnergyToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :head_frame_energy, :integer, default: 0, comment: '头像框价格：能量数'
    add_column :web_settings, :head_frame_day, :integer, default: 0, comment: '头像框价格：天数'
    add_column :web_settings, :energy_ratio, :integer, default: 0, comment: '头像框价格：赠送宝符比例中，能量的比例'
    add_column :web_settings, :baofu_ratio, :integer, default: 0, comment: '头像框价格：赠送宝符比例中，宝符的比例'
  end
end
