require_relative 'boot'

require 'rails/all'
require "rexml/document"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApiServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    # config.active_support.use_standard_json_time_format = false
    config.active_support.time_precision = 0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
