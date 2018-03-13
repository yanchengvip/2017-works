class AddContentToPromotionRedPackageRules < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_red_package_rules, :content, :string, comment: "推送消息 {user_name} 替换为触发用户的用户名  {model_name} 替换触发对象的 名称"
  end
end
