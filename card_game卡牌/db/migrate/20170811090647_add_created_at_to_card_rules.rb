class AddCreatedAtToCardRules < ActiveRecord::Migration[5.0]
  def change
    add_column :card_rules, :created_at, :datetime
    add_column :card_rules, :updated_at, :datetime
  end
end
