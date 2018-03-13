class AddContentToPromotionRedPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_red_packages, :content, :string, comment: "推送文案", default: ""
  end
end
