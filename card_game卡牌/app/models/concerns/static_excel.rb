module StaticExcel
  extend ActiveSupport::Concern
  module ClassMethods
    def download_excel
    end
    #下载
    def download_source timee
      index = "zbqibing_logstash"
      @start_time = timee[:start_time]
      @end_time = timee[:end_time]
      response = $es_client.search ({
          :index => index, :body=> {
              :size=>0,
              :query => {
                :bool => {
                  :must => [
                    {
                      :range => {
                        :@timestamp => {
                          :gte => @start_time,
                          :lte => @end_time
                        }
                      }
                    },
                    {
                      :term => {
                        "uri.keyword" => {
                          :value => "/ld/images/Statistics.png"
                        }
                      }
                    }
                  ]
                }
              },
              :aggs => {
                :from => {
                  :terms => {
                    :field => "ad_from.keyword",
                    :size => 10000
                  },
                  :aggs => {
                    :phone => {
                      :terms => {
                        :field => "phonetype.keyword",
                        :size => 10000
                      },
                      :aggs => {
                        :x_forword_for => {
                          :cardinality => {
                            :field => "x_forword_for.keyword"
                          }
                        }
                      }
                    }
                  }
                }
              }
          }
        })
        return response["aggregations"]
    end
    #请求访问
    def request_source timee
      @start_time = timee[:start_time]
      @end_time = timee[:end_time]
      index = "zbqibing_logstash"
      response = $es_client.search ({
          :index => index, :body=> {
              :size=>0,
              :query => {
                :bool => {
                  :must => [
                    {
                      :range => {
                        :@timestamp => {
                          :gte => @start_time,
                          :lte => @end_time
                        }
                      }
                    },
                    {
                      :terms => {
                        "uri.keyword" => ["/ld/index.html", "/box/index.html"]
                      }
                    }
                  ]
                }
              },
              :aggs => {
                :from => {
                  :terms => {
                    :field => "ad_from.keyword",
                    :size => 10000
                  },
                  :aggs => {
                    :phone => {
                      :terms => {
                        :field => "user_agent.keyword",
                        :size => 10000
                      },
                      :aggs => {
                        :x_forword_for => {
                          :cardinality => {
                            :field => "x_forword_for.keyword"
                          }
                        }
                      }
                    }
                  }
                }
              }
          }
        })
        return response["aggregations"]
    end

    def request_source_day timee
      @start_time = timee[:start_time]
      @end_time = timee[:start_time]
      index = "zbqibing_logstash"
      response = $es_client.search ({
          :index => index, :body=> {
              :size=>10000,
              :query => {
                :bool => {
                  :must => [
                    {
                      :range => {
                        :@timestamp => {
                          :gte => @start_time,
                          :lte => @end_time
                        }
                      }
                    },
                    {
                      :terms => {
                        "uri.keyword" => ["/ld/index.html", "/box/index.html"]
                      }
                    }
                  ]
                }
              },
              :aggs => {
                :request => {
                  :terms => {
                    :field => "ad_from.keyword",
                    :size => 10000
                  },
                  :aggs => {
                    :phone => {
                      :terms => {
                        :field => "user_agent.keyword",
                        :size => 10000
                      }
                    }
                  }
                }
              }
          }
        })
        return response["aggregations"]
    end


    def download_source_day timee
      index = "zbqibing_logstash"
      @start_time = timee[:start_time]
      @end_time = timee[:start_time]
      response = $es_client.search ({
          :index => index, :body=> {
              :size=>0,
              :query => {
                 :bool => {
                   :must => [
                     {
                       :range => {
                         :@timestamp => {
                           :gte => @start_time,
                           :lte => @end_time
                         }
                       }
                     },
                     {
                       :term => {
                         "uri.keyword" => {
                           :value => "/ld/images/Statistics.png"
                         }
                       }
                     }
                   ]
                 }
               },
               :aggs => {
                 :request => {
                   :terms => {
                     :field => "ad_from.keyword",
                     :size => 10000
                   },
                   :aggs => {
                     :phone => {
                       :terms => {
                         :field => "user_agent.keyword",
                         :size => 10000
                       }
                     }
                   }
                 }
               }
          }
        })
        return response["aggregations"]
    end




  end
end
