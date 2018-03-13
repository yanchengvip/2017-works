# RailsSettings Model
class AppVersion < ActiveRecord::Base
  self.table_name = 'manage_app_versions'
  def self.current
    Rails.cache.fetch("app_current_version", expires_in: 60){
      ios = AppVersion.where(app_type: 'ios', active: true).order(id: :desc).last.as_json
      android = AppVersion.where(app_type: 'android', active: true).order(id: :desc).last.as_json
      {
        ios: ios, android: android
      }
    }
  end
end
