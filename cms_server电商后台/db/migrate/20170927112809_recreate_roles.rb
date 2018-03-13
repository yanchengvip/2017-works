class RecreateRoles < ActiveRecord::Migration[5.1]
  def up
    begin
      drop_table :manage_roles
    rescue Exception => e
    end
    create_table :manage_roles, comment: "角色表" do |t|
      t.string :name, comment: "角色名称", default: ""
      t.boolean :active, comment: "软删除标志", default: true
      t.timestamps
    end
  end

  def down
    # drop_table :manage_roles
  end

end
