Sidekiq.configure_server do |config|
  config.redis = { url: SYSTEMCONFIG[:redis][:url],  :namespace => 'sidekiq' }
  # config.default_worker_options = {"retry"=>true, "queues"=>["chest_order_item_queue", "chest_order_voucher_queue"]}
  # binding.pry
end

Sidekiq.configure_client do |config|
  config.redis = { url: SYSTEMCONFIG[:redis][:url], :namespace => 'sidekiq' }
  # config.sidekiq_config = "config/sidekiq.yml"
end
