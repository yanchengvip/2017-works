SYSTEMCONFIG = YAML.load_file("config/app.yml")[Rails.env].with_indifferent_access.freeze
DATABSECONFIG = YAML.load_file("config/database.yml").with_indifferent_access.freeze
$redis ||= Redis.new(:url => SYSTEMCONFIG["redis"]["url"])
