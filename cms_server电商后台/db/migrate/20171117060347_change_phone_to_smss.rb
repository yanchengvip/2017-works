class ChangePhoneToSmss < ActiveRecord::Migration[5.1]
  def change
    change_column :auction_smss, :phone, :text
  end
end
