CARDCONFIG = YAML.load_file("config/card.yml").with_indifferent_access.freeze

SYSTEMCONFIG = YAML.load_file("config/system_config.yml")[Rails.env].with_indifferent_access.freeze

ALIPAYCONFIG = YAML.load_file("config/my_alipay.yml")[Rails.env].with_indifferent_access.freeze

redis_connection = Redis.new(:url => SYSTEMCONFIG["redis"]["url"])

$redis = Redis::Namespace.new(:ruby, :redis => redis_connection)
