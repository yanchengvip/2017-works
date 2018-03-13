class Auction::Product < ApplicationRecord
  include DownloadCsv
  belongs_to :brand
  has_many :images, -> {where(active: true)}, class_name: 'Auction::Image'
  has_many :skus, -> {where(active: true)}
  has_many :values, -> {where(active: true)}
  belongs_to :provider, :class_name => "Supplier::Provider", foreign_key: 'provider_id'
  belongs_to :category1, :class_name => "Auction::Category", foreign_key: 'category1_id'
  belongs_to :category2, :class_name => "Auction::Category", foreign_key: 'category2_id'
  belongs_to :category3, :class_name => "Auction::Category", foreign_key: 'category3_id'
  belongs_to :promotion_activity, :class_name => "Auction::PromotionActivity", foreign_key: 'promotion_activity_id'

  TARGET = {'儿童' => '儿童', '男' => '男', '女' => '女', '无性别' => '无性别', '中性' => '中性', '婴幼儿' => '婴幼儿'}
  SOFT = {'柔软' => '柔软', '适中' => '适中', '偏硬' => '偏硬'}
  THICKNESS = {'薄' => '薄', '适中' => '适中', '厚' => '厚', '加厚' => '加厚'}
  RECOMMEND = {'精选' => '精选', '最新' => '最新', '热门' => '热门'}
  ELASTIC = {'无弹' => '无弹', '微弹' => '微弹', '中弹' => '中弹', '强弹' => '强弹'}
  COLORS = { '红' => 'red', '粉' => 'pink', '紫' => 'purple', '蓝' => 'blue', '绿' => 'green', '黄' => 'yellow', '橙' => 'orange', '棕' => 'brown', '灰' => 'gray', '黑' => 'black', '白' => 'white', '银' => 'silver', '彩' => 'multicolor' }
  PUBLISHED = {true => '上架', false => '下架'}
  CHECKSTATUS = {1 => '待买手审核', 2 => '待总监审核', 3 => '待财务审核'}


# 1.创建供应商时，合作类型新增“自采”类型
# 2.在供应商上传商品并提交审核后，系统自动计算利润率，计算公式如下：
# 平台类型供应商的利润率=（（优众价 - 采购价）/1.06）/优众价
# 代销类型供应商的利润率=（（优众价/1.17 - 采购价/（1+供应商适用税率））/（优众价/1.17））/(优众价/1.17)
# 平台兼代销、自采两种类型的供应商，计算公式与代销一致

# 计算公式如下：
# 平台类型供应商的利润率=1-销售底价（or采购价）/优众价
# 优众自营、代销类型及代销兼平台供应商的利润率=1-销售底价（or采购价）/（1+供应商适用税率）/（优众价/1.17）
  def profit_margin
    if self.provider.partner_type == 1 #平台
      # ((discount - provider_price)/1.06)/discount
      1 - provider_price / discount
    else
      # ((discount/1.17 - provider_price/(1+ self.provider.invoice)) / (discount/1.17)) / (discount/1.17)
      1 - (provider_price / (1 + self.provider.invoice) / (self.discount / 1.17))
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

  def update_values!(input_category_attributes_param, category_attributes_params, attributes_names_param)
    self.values.where.not(attribute_id: 0).update_all(active: false)
    category_attributes_params && category_attributes_params.each do |k, vs|
      vs.each do |v|
        self.values.create!(attribute_id: k, content: v, attribute_name: attributes_names_param[k]['atr_name'])
      end
    end
    input_category_attributes_param && input_category_attributes_param.each do |k, vs|
      self.values.create!(attribute_id: k, content: vs.first, attribute_name: attributes_names_param[k]['atr_name'])
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

  def shelf_sync!
    sp = Supplier::Product.find(self.id)
    sp.update_attribute(:published, self.published) if sp
  end


end
