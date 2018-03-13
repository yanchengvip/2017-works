class CreateManageAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :manage_authorities, commnet: "路由权限表" do |t|
      t.string :name, comment:"权限名称"
      t.string :action, comment: "路由 如 create_auction_products"
      t.boolean :active, default: true, comment: "软删除标志 false 已删除"
      t.timestamps
    end
  end
end
