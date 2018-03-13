SYSTEMCONFIG = YAML.load_file("config/system_config.yml")[Rails.env].with_indifferent_access.freeze

$redis = Redis.new(:url => SYSTEMCONFIG["redis"]["url"])
