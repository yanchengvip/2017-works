module CsvDataHelper
  extend ActiveSupport::Concern
  module ClassMethods
    #兑换订单统计下载
    def order_info_csv_data params
      data_arr = []
      index = SYSTEMCONFIG[:es_table_prefix] + "mall_orders"
      start_time = DateTime.parse(params[:created_at_begin]&.to_s).strftime('%Y-%m-%dT00:00:01.000Z').to_s if params[:created_at_begin].present?
      end_time = DateTime.parse(params[:created_at_end]&.to_s).strftime('%Y-%m-%dT23:59:59.000Z').to_s if params[:created_at_end].present?
      if params[:created_at_begin].present? && params[:created_at_end].present?
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :range => { :created_at => { :gte => start_time, :lte => end_time }}
                },
                :size=>10000
            }
          })
        else
          response = $es_client.search ({
              :index => index, :body=> {
                  :query => {
                    :match_all => {}
                  },
                  :size=>10000
              }
            })
        end
        results = response["hits"]["hits"]
        results.each do |result|
            product = MallProduct.find(result["_source"]["mall_product_id"].to_i)
            data_arr << [DateTime.parse(result["_source"]["created_at"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s,product&.sku, product&.inventory_place, result["_source"]["product_name"], product&.market_price.to_f,MallProduct::EXCHANGETYPE[product&.exchange_type],
              product.micro_ticket,product.micro_score,result["_source"]["consignee"],result["_source"]["mobile"], result["_source"]["shipping_address"], result["_source"]["postage_pay_status"],result["_source"]["postage"],MallOrder::STATUS[result["_source"]["status"].to_i]]
        end
        return data_arr
    end

    #中奖订单统计
    def winning_order_info_csv_data params
      data_arr = []
      index = SYSTEMCONFIG[:es_table_prefix] + "battle_winning_record"
      start_time = DateTime.parse(params[:created_at_begin]&.to_s).strftime('%Y-%m-%dT00:00:00.000Z').to_s if params[:created_at_begin].present?
      end_time = DateTime.parse(params[:created_at_end]&.to_s).strftime('%Y-%m-%dT23:59:59.000Z').to_s if params[:created_at_end].present?
      if params[:created_at_begin].present? && params[:created_at_end].present?
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :range => { :create_time => { :gte => start_time, :lte => end_time }}
                },
                :size=>10000
            }
          })
      else
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :match_all => {}
                },
                :size=>10000
            }
          })
      end
      results = response["hits"]["hits"]
      results.each do |result|
        address = Address.where(:id => result["_source"]["address_id"]&.to_i)
        data_arr <<
        [DateTime.parse(result["_source"]["create_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s,
        result["_source"]["good_name"],
        result["_source"]["good_price"].to_f,
        result["_source"]["battle_code"],
        result["_source"]["luck_num"],
        DateTime.parse(result["_source"]["claim_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s,
        result["_source"]["user_name"],
        result["_source"]["consignee"],
        result["_source"]["mobile"],
        address&.first&.detailed_address,
        BattleWinningRecord::CLAIMSTATUS[result["_source"]["claim_status"]],
        BattleWinningRecord::SHIPPINGSTATUS[result["_source"]["shipping_status"]]]
      end
      return data_arr

    end

  end
end
