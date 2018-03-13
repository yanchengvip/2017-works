module EsModule
  require 'mysql2'
  require 'elasticsearch'
  def self.init
    client = Mysql2::Client.new(YAML.load_file("config/database.yml")[Rails.env].with_indifferent_access)
    es_client = Elasticsearch::Client.new( YAML.load_file("config/system_config.yml")[Rails.env].with_indifferent_access[:es_config])
    es_table_prefix = YAML.load_file("config/system_config.yml")[Rails.env].with_indifferent_access[:es_table_prefix]

    tables = client.query("show tables").to_a.map{|x| x.values}.flatten

    # es_client.indices.delete index: "_all"
    tables.each do |t|
      columns = client.query("desc `#{t}`").to_a
      # unless(es_client.indices.exists? index: t)
        properties = {}
        columns.each do |x|
          if(x["Type"] =~ /varchar/ ||  x["Type"] =~ /text/ )
            properties[x["Field"]] = { type: 'keyword' }
          end
        end
        begin
          es_client.indices.delete index: es_table_prefix+t
          es_client.indices.create index: es_table_prefix+t,
              body: {
                  mappings: {
                    document: {
                      properties: properties
                    }
                  }
                }
        rescue Exception => e

        end


        # es_client.indices.put_mapping index: t, type: 'type', body: {
        #       type: {
        #         properties: properties
        #       }
        #     }
      # end
    end
  end
end
