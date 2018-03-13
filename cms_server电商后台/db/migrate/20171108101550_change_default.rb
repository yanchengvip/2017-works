class ChangeDefault < ActiveRecord::Migration[5.1]
  def change
    begin
      change_column :retail_carts, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e

    end
  end
end
