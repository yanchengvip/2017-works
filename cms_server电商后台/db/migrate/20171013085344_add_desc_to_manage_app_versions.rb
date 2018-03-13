class AddDescToManageAppVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :manage_app_versions, :desc, :text, comment: "更新描述"
    change_column :manage_app_versions, :active, :boolean, comment: "软删", default: true
  end
end
