class Auction::Theme < ApplicationRecord
  THEME_TYPE = { 0 => '专题', 1 => '闪购', 2 => "APP推广栏" }
  TARGET = {'nogender' => '无性别', 'children' => '儿童', 'men' => '男', 'women' => '女'}
  SORT_KEY = {'published_at' => '发布时间', 'percent' => '折扣', 'readings_count' => '热度', 'arrived_at' => '上架时间', 'price' => '价格'}
  SORT_METHOD = { 'desc' => '降序', 'asc' => '升序' }
  before_save :update_search_params, :update_products

  def get_search_params page = 1,  per_page = 40
    params = {
      keyword: self.keyword,
      page: page,
      per_page: per_page,
      where: {
        brand_id: self.brand_id.split(","),
        target: self.target,
        unsold_count: {gteq: self.unsold_count_gteq},
        category1_id: self.category1_id,
        category2_id: self.category2_id,
        category3_id: self.category3_id,
        price: {gt: self.price_gt, lt: self.price_lt},
      },
      order:{
      self.sort_key => self.sort_method
      },
    }
    clear_hash(params)
  end

  def get_products page = 1,  per_page = 3
    begin
      conn = Faraday.new
      res = conn.post(Setting.api_host + "/api/auction/products", get_search_params(page, per_page))
      json = JSON.parse(res.body)
      if json["status"] == 200
        json["data"]["products"]
      else
        []
      end
    rescue Exception => e
      p e
      []
    end
  end

  def clear_hash params
    t = {}
    params.each do |k, v|
      if v.is_a? Hash
        v = clear_hash(v)
        t[k] = v unless v.blank?

      else
        unless v.blank?
          t[k] = v
        end
      end
    end
    t
  end




  def update_products
    self.products = get_products.to_json
  end

  def update_search_params
    self.search_params = get_search_params(1, 40).to_json
  end

  def self.auto_shelf
    # themes = self.active
    wait_ups = self.active.where("publish_time <= ? and down_time >= ? and published = 0", Time.now, Time.now)
    wait_ups.update_all(published: true) if !wait_ups.blank?
    puts wait_ups&.pluck(:id).inspect + '??????????????????'
    wait_downs = self.active.where("down_time <= ? and published = 1", Time.now)
    wait_downs.update_all(published: false) if !wait_downs.blank?
  end


end
