class ChangeColumnStatusAdmins < ActiveRecord::Migration[5.0]
  def change
    change_column :admins, :status, :boolean, default: true, comment: '是否允许登录 1允许，0不允许'
  end
end
