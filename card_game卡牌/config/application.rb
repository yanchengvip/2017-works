require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CardGame
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_types = [:datetime, :time]
    # config.i18n.locale = 'zh-CN'
    config.i18n.default_locale = 'zh-CN'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.eager_load_paths += %W(#{Rails.root}/lib)
    config.active_job.queue_adapter = :sidekiq
  end
end
