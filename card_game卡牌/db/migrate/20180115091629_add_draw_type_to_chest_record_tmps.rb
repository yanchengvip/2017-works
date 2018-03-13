class AddDrawTypeToChestRecordTmps < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_record_tmps, :draw_type, :integer, default: 0, comment: "抽奖类型0 固定 1随机"
  end
end
