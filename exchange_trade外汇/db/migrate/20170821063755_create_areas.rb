class CreateAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :areas, comment: "地区表" do |t|
      t.integer :area_id, comment: "上级地区id", default: 0
      t.string :name, comment: "名称"
      t.boolean :active, comment: "软删除标志", default: true

      t.timestamps
    end
  end
end
