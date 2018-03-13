require 'elasticsearch/api'
require 'elasticsearch/transport'
class ElasticClient
  include Elasticsearch::API
  $es_client = Elasticsearch::Client.new host: SYSTEMCONFIG[:es_config][:hosts],request_timeout: 30*60,randomize_hosts: true,retry_on_failure: 5
end
