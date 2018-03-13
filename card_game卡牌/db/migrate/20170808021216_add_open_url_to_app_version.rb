class AddOpenUrlToAppVersion < ActiveRecord::Migration[5.0]
  def change
    add_column :app_version, :open_url, :string, default: '', comment: '打开链接地址'
  end
end
