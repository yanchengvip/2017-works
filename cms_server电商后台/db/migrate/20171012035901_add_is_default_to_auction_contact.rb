class AddIsDefaultToAuctionContact < ActiveRecord::Migration[5.1]
  def change
    begin
        add_column :auction_contacts, :is_default, :boolean, comment: "是否是默认地址"
        add_index :auction_contacts, [:user_id, :active, :is_default], unique: true, name: "auction_contacts_is_default"
    rescue Exception => e

    end
  end
end
