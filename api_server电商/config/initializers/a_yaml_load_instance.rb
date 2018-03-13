SYSTEMCONFIG = YAML.load_file("config/app.yml")[Rails.env].with_indifferent_access.freeze
ALIPAYCONFIG = YAML.load_file("config/my_alipay.yml")[Rails.env].with_indifferent_access.freeze
WECAHTCONFIG = YAML.load_file("config/wechat.yml")[Rails.env].with_indifferent_access.freeze