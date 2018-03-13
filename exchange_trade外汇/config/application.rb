require_relative 'boot'

require 'rails/all'
require "rexml/document"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExchangeTrade
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    config.eager_load_paths += %W(#{Rails.root}/lib)
    config.active_job.queue_adapter = :sidekiq
    config.active_record.belongs_to_required_by_default = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
