class CreateManageAppVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :manage_app_versions, comment: "app版本列表" do |t|
      t.string :app_type, comment: "app类型 ios/android"
      t.string :app_version, comment: "版本"
      t.string :name, comment: "名称"
      t.string :mode, comment: "更新模式"
      t.string :version_code, comment: "版本号"
      t.string :url, comment: "下载地址"
      t.boolean :active, comment: "软删标志"

      t.timestamps
    end
    add_index :manage_app_versions, [:app_type, :app_version, :version_code, :active], unique: true, name: "app_version_index"
  end
end
