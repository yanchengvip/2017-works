class Supplier::Product < ApplicationRecord
  include DownloadCsv
  scope :own, ->(provider_id) { where(provider_id: provider_id) }
  has_many :skus, -> { where(active: true) }, dependent: :destroy, :class_name => "Auction::Sku"
  belongs_to :brand, :class_name => "Auction::Brand", foreign_key: 'brand_id'
  has_many :images, -> { where(active: true) }, class_name: 'Auction::Image'
  has_many :values, -> { where(active: true) }, dependent: :destroy, class_name: 'Auction::Value'
  belongs_to :provider, :class_name => "Supplier::Provider", foreign_key: 'provider_id'
  belongs_to :category1, :class_name => "Auction::Category", foreign_key: 'category1_id'
  belongs_to :category2, :class_name => "Auction::Category", foreign_key: 'category2_id'
  belongs_to :category3, :class_name => "Auction::Category", foreign_key: 'category3_id'
  has_many :review_logs, class_name: 'Auction::ReviewLog', as: :table
  # validates :category1_id, numericality: {greater_than: 0}
  # validates :category2_id, numericality: {greater_than: 0}, allow_nil: true
  # validates :category3_id, numericality: {greater_than: 0}, allow_nil: true
  # validates_presence_of :spec_pic, :major_pic, :provider_price, :discount, :price, :identifier, :name, :brand_id, :description, :category1_id, :target
  # validates :provider_price, numericality: {greater_than: 0}
  # validates :discount, numericality: {greater_than: 0}
  # validates :price, numericality: {greater_than: 0}

  attr_accessor :is_micro, :is_hot, :micro_amount,:excel_file

  # 商品状态
  STATUS = {0 => '未提交审核', 1 => '待买手审核', 2 => '待总监审核', 3 => '待财务审核', 4 => '待编辑审核', 5 => '审核结束'}
  SEARCHPUBLISHED = {true => '上架', false => '下架'}
  SEARCHSTATUS = {0 => '未提交审核', 5 => '审核通过'}
  COLORS = { '红' => 'red', '粉' => 'pink', '紫' => 'purple', '蓝' => 'blue', '绿' => 'green', '黄' => 'yellow', '橙' => 'orange', '棕' => 'brown', '灰' => 'gray', '黑' => 'black', '白' => 'white', '银' => 'silver', '彩' => 'multicolor' }


  # 1.创建供应商时，合作类型新增“自采”类型
  # 2.在供应商上传商品并提交审核后，系统自动计算利润率，计算公式如下：
  # 平台类型供应商的利润率=（（优众价 - 采购价）/1.06）/优众价
  # 代销类型供应商的利润率=（（优众价/1.17 - 采购价/（1+供应商适用税率））/（优众价/1.17））/(优众价/1.17)
  # 平台兼代销、自采两种类型的供应商，计算公式与代销一致
  def profit_margin
    if self.provider.partner_type == 1 #平台
      # ((discount - provider_price)/1.06)/discount
      1 - provider_price / discount
    else
      # ((discount/1.17 - provider_price/(1+ self.provider.invoice)) / (discount/1.17)) / (discount/1.17)
      1 - (provider_price / (1 + self.provider.invoice) / (self.discount / 1.17))
    end
  end


  # 保存商品sku
  def save_skus! sku_params, provider_id
    sku_params && sku_params.each do |sku_param|
      self.skus.create!(sku_param.permit!.to_hash.slice('name', 'amount', 'code').merge(provider_id: provider_id))
    end
  end

  # 修改商品sku
  def update_skus!(sku_params, provider_id)
    sku_params && sku_params.each do |item_param|
      if item_param['id'] && (sku = self.skus.where(id: item_param['id'].to_i).first)
        sku.update_attributes!(item_param.permit!.slice('name', 'amount', 'code'))
      elsif item_param['id'].blank?
        self.skus.create!(item_param.permit!.slice('name', 'amount', 'code').merge(provider_id: provider_id))
      end
    end
  end

  def last_category
    unless category3_id.blank? || category3_id == 0
      return Auction::Category.find category3_id
    end

    unless category2_id.blank? || category2_id == 0
      return Auction::Category.find category2_id
    end

    unless category1_id.blank? || category1_id == 0
      return Auction::Category.find category1_id
    end
  end

  def update_values!(input_category_attributes_param, category_attributes_params, attributes_names_param, custom_values_param)
    self.values.update_all(active: false)
    category_attributes_params && category_attributes_params.each do |k, vs|
      vs.each do |v|
        self.values.create!(attribute_id: k, content: v, attribute_name: attributes_names_param[k]['atr_name'])
      end
    end
    input_category_attributes_param && input_category_attributes_param.each do |k, vs|
      self.values.create!(attribute_id: k, content: vs.first, attribute_name: attributes_names_param[k]['atr_name'])
    end
    custom_values_param && custom_values_param.each do |cvm|
      self.values.create!(attribute_id: 0, content: cvm['content'], attribute_name: cvm['attribute_name'])
    end

  end

  def sync! user_id
    raise 'error' unless self.status == 5

    self.update_attribute(:published, true)

    auction_product = Auction::Product.find_by(id: self.id)
    product = Auction::Product.new
    if auction_product.blank?
      auction_product = Auction::Product.create!(self.attributes.except("created_at", "updated_at").slice(*product.attributes.keys).merge(user_id: user_id))
      # auction_product = Auction::Product.create!(self.attributes.except("created_at", "updated_at"))
    else
      # auction_product.update_attributes!(self.attributes.except("created_at", "updated_at"))
      auction_product.update_attributes!(self.attributes.except("created_at", "updated_at").slice(*product.attributes.keys).merge(user_id: user_id))
    end
  end

  def save_images! images_param, user_id
    images_param && images_param.each do |image|
      if image['id'] && (img = self.images.where(id: image['id'].to_i).first)
        img.update_attributes!(image.permit!.slice('large', 'description', 'sequence').merge(user_id: user_id))
      else
        self.images.create!(large: image['large'], description: image['description'], sequence: image['sequence'], user_id: user_id) if image['id'].blank? && image['large'].present?
      end
    end
  end


  # excle导入商品
  def self.import_products_from_excel excel_url,current_user
    xlsx = Roo::Spreadsheet.open(excel_url)
    provider_id = current_user.id
    xlsx.each_with_index do |row, i|
      next if i == 0
      product_id = row[0]
      sku_names = row[15]&.split(',')
      sku_amounts = row[16]&.split(',')
      sku_codes = row[17].present? ? row[17].split(',') : []
      if !sku_names.present? || !sku_amounts.present?
        Rails.logger.info('x'*30 +'sku为空，这条记录不能创建' + "identifier:#{row[1]}-name: #{row[2]}-provider_id:#{provider_id}")
        next
      end
      sp = {identifier: row[1], name: row[2], price: row[3], discount: row[4], provider_price: row[5],
            brand_id: row[6], description: row[7], color_name: row[8], relate_product_ids: row[9],
            category1_id: row[10], category2_id: row[11], category3_id: row[12], target: row[13],
            match_product_ids: row[14], provider_id: provider_id,
            unsold_count: sku_amounts.inject(0) { |sum, x| sum += x.to_i }

      }

      if product_id.present?
        #修改商品
        begin
          ActiveRecord::Base.transaction do
            supplier_product = Supplier::Product.includes(:skus).where(id: product_id).first
            supplier_product.update_attributes!(sp)
            sku_names.each_with_index do |name, i|
              is_create = true
              supplier_product.skus.each do |sku|
                if sku.name == name
                  is_create = false
                  sku.update_attributes!(name: name, amount: sku_amounts[i], code: sku_codes[i],
                                         provider_id: provider_id)
                end
              end
              if is_create
                supplier_product.skus.create!(name: name, amount: sku_amounts[i], code: sku_codes[i],
                                              provider_id: provider_id)
              end
            end
          end
        rescue Exception => e
          Rails.logger.info('='*30 +'商品导入失败---' + e.as_json)
        end
        next
      end
      supplier_product = Supplier::Product.new(sp)
      begin
        ActiveRecord::Base.transaction do
          if supplier_product.save!
            sku_names.each_with_index do |name, i|
              supplier_product.skus.create!(name: name, amount: sku_amounts[i], code: sku_codes[i],
                                            provider_id: provider_id)
            end

          end
        end
      rescue Exception => e
        Rails.logger.info('='*30 +'商品导入失败!!!' + e.as_json)
      end

    end
  end


end
