class AddIsDoubleToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :is_double, :boolean, default: false, comment: '是否使用效果翻倍 1:是 0:否，目前默认翻两倍'
  end
end
