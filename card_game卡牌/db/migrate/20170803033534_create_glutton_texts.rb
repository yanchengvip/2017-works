class CreateGluttonTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :glutton_texts do |t|
      t.decimal :blood_percent, precision: 4, scale: 3, default: 0, comment: '饕餮血量百分比'
      t.string :show_text, default: '', comment: '提示语言'
      t.boolean :delete_flag, default: false, comment: '删除标志 0:未删除，1:已删除'

      t.timestamps
    end
  end
end
