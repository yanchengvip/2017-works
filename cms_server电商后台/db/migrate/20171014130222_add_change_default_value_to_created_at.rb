class AddChangeDefaultValueToCreatedAt < ActiveRecord::Migration[5.1]
  def up
    begin
      change_column :about_articles, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_articles, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_jobs, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_jobs, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_links, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_links, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_people, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_people, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_users, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :about_users, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :ar_internal_metadata, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :ar_internal_metadata, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_ads, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_ads, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_attributes, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_attributes, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_brand_images, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_brand_images, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_brands, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_brands, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_calls, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_calls, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_cards, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_cards, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_categories, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_categories, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_cities, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_cities, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_clicks, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_clicks, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_contacts, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_contacts, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_countries, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_countries, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_coupons, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_coupons, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_customs_entries, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_customs_entries, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_events, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_events, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_fanships, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_fanships, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_favorites, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_favorites, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_images, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_images, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_items, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_items, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_items_updatings, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_items_updatings, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_levels, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_levels, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_links, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_links, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_locations, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_locations, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_mails, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_mails, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_mails_updatings, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_mails_updatings, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_malls, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_malls, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_messages, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_messages, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_multibuys, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_multibuys, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_notifications, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_notifications, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_pic_ads, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_pic_ads, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_pictures, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_pictures, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_product_operation_images, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_product_operation_images, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_productions, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_productions, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_products, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_products, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_promotions, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_promotions, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_providers, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_providers, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_provinces, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_provinces, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_score_items, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_score_items, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_seckills, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_seckills, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_skus, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_skus, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_smss, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_smss, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_themes, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_themes, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_towns, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_towns, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_trades, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_trades, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_trades_updatings, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_trades_updatings, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_transactions, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_transactions, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_units, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_units, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_usages, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_usages, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_users, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_users, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_users_updatings, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_users_updatings, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_values, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_values, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_voucher_trades, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_voucher_trades, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_vouchers, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :auction_vouchers, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_accounts, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_accounts, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_connections, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_connections, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_reports, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_reports, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_users, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :core_users, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :data_common_files, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :data_common_files, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :dataset_zips, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :dataset_zips, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :devices, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :devices, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :devices_users, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :devices_users, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_app_versions, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_app_versions, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_authorities, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_authorities, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_authority_role_relationships, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_authority_role_relationships, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_editor_role_relationships, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_editor_role_relationships, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_editors, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_editors, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_grants, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_grants, :created_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e
    end
    begin
      change_column :manage_roles, :updated_at, :datetime,  default:  -> { 'NOW()'}
    rescue Exception => e

    end
  end
  def down
  end
end
