class Auction::Product < Base
  # self.table_name = 'auction_products'
  belongs_to :brand
  def self.voucher_trade_xml_options
    {
      only: [:id, :major_pic, :discount, :micro_amount],
      include: {
        brand: {
          only: [:id, :name]
        }
      }
    }
  end
  self.xml_options = {
    # :only => [ :brand],
    # :only => [ :id, :name, :description, :gender, :occasion, :bg_color, :bg_pic, :bg_pic2, :list_pic, :swf ].freeze,
    :include => {
        auction_product: {
          :only => [ :id, :name, :description, :pic, :price, :discount, :spec_pic, :color_pic, :color_name,
            :identifier, :keywords, :relate_product_ids, :category1_id, :category2_id, :brand_id, :published_at, :match_product_ids, :major_pic, :remark,
            :label, :prefix, :category3_id, :foreign_payment, :keywords2, :use_voucher, :provider_id, :published, :mall_id, :unsold_count, :location_id, :status, :measure_description, :measure_table, :happy, :images, :category1, :category2,
            :seckill_price,:seckill_begin_time,:seckill_end_time
          ].freeze,
          :include => {
            images: {
              :only => [ :id, :large, :description, :product_id ].freeze,
            },
            category1: {
              :only => [:id, :name, :measures, :ranges, :description, :measure_properties, :measure_pic ].freeze
            },
            category2: {
              :only => [:id, :name, :measures, :ranges, :description, :measure_properties, :measure_pic ].freeze
            }
          }
        },
        :relate_products => {
          :only => [ :id, :color_pic, :color_name].freeze,
        },
        :match_products => {
          :only => [ :id, :name, :price, :discount, :description, :spec_pic, :color_pic, :color_name, :identifier, :keywords, :relate_product_ids, :category1_id, :category2_id, :brand_id, :published_at, :match_product_ids, :major_pic, :remark, :label, :prefix, :category3_id, :foreign_payment, :keywords2, :use_voucher, :provider_id, :published, :status ].freeze,
        },
        :skus => { :only => [ :id, :product_id, :active, :name, :amount, :code, :created_at, :updated_at, :provider_id ] }.freeze,
        :brand => { :only => [ :id, :name, :chinese, :initial, :title, :description, :country_id, :year, :keywords, :recommend ] }.freeze,
        :auction_values => { :only => [:id, :product_id, :attribute_id, :content, :active, :created_at, :updated_at, :attribute_name, :lock_version]}.freeze
      }.freeze,
  }.freeze

  # def self.options params
  #   post("auction/products/options", params)
  # end

  def self.getProduct params
    post("/shop-service/product/getProduct", params)
  end
end
