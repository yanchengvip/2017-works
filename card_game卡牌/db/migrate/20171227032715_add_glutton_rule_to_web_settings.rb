class AddGluttonRuleToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :glutton_rule, :text, comment: '饕餮规则说明文案'
  end
end
