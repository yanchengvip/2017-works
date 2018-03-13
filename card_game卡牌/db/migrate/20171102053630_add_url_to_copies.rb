class AddUrlToCopies < ActiveRecord::Migration[5.0]
  def change
    add_column :copies, :url, :string, dafault: '', comment: '链接地址，通关密钥（密钥来源）分类用'
  end
end
