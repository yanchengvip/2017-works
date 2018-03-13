namespace :shelf do
  desc '礼包自动上架'
  task :package_onshelf => :environment do |t, args|
    begin
      Package.auto_onshelf!
    rescue Exception => e
      p e.to_s
      Rails.logger.info('礼包自动上架失败' + e.to_s)
    end

    ActiveRecord::Base.clear_active_connections!
  end

  desc '礼包自动下架'
  task :package_offshelf => :environment do |t, args|
    begin
      Package.auto_offshelf!
    rescue Exception => e
      p e.to_s
      Rails.logger.info('礼包自动下架失败' + e.to_s)
    end

    ActiveRecord::Base.clear_active_connections!
  end
end
