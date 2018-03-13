class Auction::ProductsController < ApplicationController

  #  商品列表
  def index
      params[:where] ||= {}
      params[:order] ||= {}
      params[:where][:brand_id] ||= params[:where_brand_id] if params[:where_brand_id]
      params[:where][:category1_id] ||= params[:where_category1_id] if params[:where_category1_id]
      case params[:name]
      when 'latest'; params[:order][:arrived_at] = 'desc'
      when /men|women/; params[:where][:target] = params[:name]
      end

      page = (params[:page] || 1).to_i

      per_page = (params[:per_page] || 80).to_i

      params[:where][:target] = { 'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }[params[:where][:target]] || params[:where][:target] if params[:where][:target]

      params[:where][:target].map! { |t| { 'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }[t] || t } if params[:where][:target].is_a?(Array)

      params[:where][:unsold_count] = { :gt => 0 } if params[:where][:unsold_count].blank?

      options = [["wt", "json"], ["indent", "on"],["fl", "brand_name"], ["fl", "id"], ["fl", "product_name"], ["fl", "price"], ["fl", "discount"], ["fl", "major_pic"], ["fl", "label"], ["fl", "unsold_count"], ["start", (page-1)*per_page], ["rows", per_page], ["fq", "active:true"], ["fq", "published:true"], ["forceElevation", true]]

      options << ["fq", (params[:where][:target].to_a + [(params[:where][:target].to_a & %w[男 女]).empty? ? nil : '中性']).compact.uniq.map { |t| "target:#{t}" }.join(' OR ')] if params[:where][:target]

      options << ["q", params[:keyword].blank? ? "*:*" : params[:keyword].to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/){|c|"\\"+c}]



      _t = params[:where].slice(:measure, :id, :mall_id, :location_id, :category1_id, :category2_id, :category3_id, :brand_id, :multibuy_id, :color, :recommend, :unsold_count, :arrived_at, :updated_at).merge(params[:where][:price] ? { :discount => params[:where][:price] } : {})

      options += _t.as_json.map{|f, value| value.is_a?(Hash) ? value.map{|op, v| v = v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/){|c|"\\"+c}; ['fq', { 'eq' => "#{f}:#{v}", 'noteq' => "-#{f}:#{v}", 'gteq' => "#{f}:[#{v} TO *]", 'lteq' => "#{f}:[* TO #{v}]", 'gt' => "#{f}:{#{v} TO *}", 'lt' => "#{f}:{* TO #{v}}", }[{ '=' => 'eq', '<>' => 'noteq', '!=' => 'noteq', '>=' => 'gteq', '<=' => 'lteq', '>' => 'gt', '<' => 'lt' }[op]||op]] } : [['fq', value.to_a.map { |v| "#{f}:#{v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/){|c|"\\"+c}}" }.join(' OR ')]] }.inject([], &:+)

      options << ["sort", (o = params[:order].slice(:percent, :scarcity, :readings_count, :point, :arrived_at, :updated_at).merge(params[:order][:price] ? { :discount => params[:order][:price] } : {}).merge(params[:order][:created_at] ? { :arrived_at => params[:order][:created_at] } : {}).as_json.map{|k, v| "#{k} #{v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/){|c|"\\"+c}}" }.join(',')) && !o.blank? ? o : "published_at desc"]

      options += %w[brand_id  category1_id category2_id category3_id target color measure].keep_if{|field| params[:where][field].blank? }.map{|field| ["facet.field", field] } + [["facet", "true"], ["facet.sort", "count"], ["facet.mincount", 1], ["facet.limit", 100], ["facet.field", "searchable_values"], ["f.searchable_values.facet.limit", 10000]] + (params[:where][:price] ? [] : [["facet.range", "discount"], ["f.discount.facet.range.start", 0], ["f.discount.facet.range.end", 1000000], ["f.discount.facet.range.gap", 2000]])# if page == 1

      logger.info url = "#{Setting.solr_url}/solr/zhcore/select?#{options.map{|k,v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join('&')}"
      data = JSON.parse(Timeout::timeout(10) { RestClient.get(url).body }) rescue {}

      @products_count = data['response']['numFound'].to_i

      if data['facet_counts']
        @products_facet = data['facet_counts']['facet_fields'].slice(*%w[brand_id location_id category1_id category2_id category3_id target color measure]).map{|field, values| { field.to_sym => values.each_slice(2).map{|value, count| { :value => %w[brand_id location_id category1_id category2_id category3_id].include?(field) ? value.to_i : value, :count => count } } } }.inject({}, &:merge)

        @products_facet.merge!(:price => (p = data["facet_counts"]["facet_ranges"] && data["facet_counts"]["facet_ranges"]["discount"]) && p["counts"].each_slice(2).map{|value, count| { :value => [value.to_i, value.to_i+p["gap"].to_i-1], :count => count } } || [])

        @products_facet = @products_facet.reject{|k,v| v.blank? } || {}

        @filters = @products_facet.slice(*%w[brand_id location_id category1_id category2_id category3_id target color measure].map(&:to_sym)).map{|field, values| { field => (values||[]).map{|v| v[:value] } } }.inject({}, &:merge).merge(:values => (@products_facet[:values]||[]).map{|value| { value[:name] => value[:options].map{|option| option[:value] } } }.inject({}, &:merge))
        %w[brand_id location_id category1_id category2_id category3_id target color measure].each{|field| @filters[field.to_sym] ||= [] }
      end

    @products = data['response']['docs']
    @products.each do |p|
      p[:name] = p["product_name"]
    end
    @brands = Rails.cache.fetch("auction_brands_json", expires_in: 300){
      brands_data = ActiveRecord::Base.connection.select_all("select id, name, initial from auction_brands where active = true").to_hash
      res = {}
      brands_data.each do |x|
        res[x["id"]] = x
      end
      res
    }.with_indifferent_access
    @categories = Rails.cache.fetch("auction_categories_json", expires_in: 300){
      categories_data = ActiveRecord::Base.connection.select_all("select id, name from auction_categories where active = true").to_hash
      res = {}
      categories_data.each do |x|
        res[x["id"]] = x
      end
      res
    }.with_indifferent_access

    @products_facet[:brand_id].each do |x|
      begin
        x[:name] = @brands[x[:value]][:name]
        x[:initial] = @brands[x[:value]][:initial]
      rescue Exception => e
      end
    end if @products_facet[:brand_id]

    @products_facet[:category1_id].each do |x|
      begin
        x[:name] = @categories[x[:value]][:name]
      rescue Exception => e
      end
    end if @products_facet[:category1_id]
    @products_facet[:category2_id].each do |x|
      begin
        x[:name] = @categories[x[:value]][:name]
      rescue Exception => e
      end
    end if @products_facet[:category2_id]

    @products_facet[:category3_id].each do |x|
      begin
        x[:name] = @categories[x[:value]][:name]
      rescue Exception => e
      end
    end if @products_facet[:category3_id]
    render json: {data: {products: @products, products_count: @products_count, products_facet: @products_facet}, status: 200, msg: "success"}
  end

  #  商品详情
  #
  # GET /auction/products/1
  #
  # @param id [integer] 商品id
  #
  # @return ({data:{auction_product: Array<Auction::Product>}, status: 200})
  # @author zhixin <zhixin.he@ihaveu.net>
  def show
    begin
      res = Auction::Product.getProduct({'productId': params[:id].to_i})
      Rails.logger.info('------------------')
      if res[:comm][:code] == "200"
        return render json: {status: 200, msg: "获取商品详情成功", data: res[:data].slice_as_json(Auction::Product.xml_options)}
      end
      return render json: {status: 500, msg: '获取商品详情失败1', data: {}}
    rescue Exception => e
      Rails.logger.info('+++++++++++++++'+e.to_s)
      return render json: {status: 500, msg: '获取商品详情失败2', data: {}}
    end

  end

end
