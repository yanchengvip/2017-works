url = SYSTEMCONFIG["redis"]["sidekiq"]
redis_config = {
    url: url,
    namespace: 'sidekiq',
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end