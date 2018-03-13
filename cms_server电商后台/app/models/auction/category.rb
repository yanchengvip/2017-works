class Auction::Category < ApplicationRecord
  belongs_to :parent, class_name: 'Auction::Category', foreign_key: 'parent_id'
  # belongs_to :parent, -> {where.not(parent_id: nil)}, class_name: 'Auction::Category', foreign_key: 'parent_id'
  belongs_to :user, class_name: 'Core::Account', foreign_key: 'user_id'

  scope :level_one, -> {where(parent_id: nil)}

  # 优先
  PRIORITY = {1 => '入库时间', 2 => '过期时间', 3 => '采购类型和入库时间', 4 => '采购类型和入库时间和成本价', 5 => '随机'}
  PUBLISH_STATUS = {0 => '未发布', 1 => '已发布'}


  def save_category!(attribute_ids_param)
    self.attribute_ids = attribute_ids_param.split(',').flatten.select{|a| !a.blank?}.join(',')
    self.save!
  end

  def update_category!(params, attribute_ids_param)
    new_attribute_ids = attribute_ids_param.split(',').flatten.select{|a| !a.blank?}.join(',')
    self.update_attributes!(params.merge!(attribute_ids: new_attribute_ids))
  end

  def children
    Auction::Category.active.where(parent_id: self.id)
  end

  def own_attributes
    return nil if attribute_ids.blank?
    ais = attribute_ids.split(',').map(&:to_i)
    abts = Auction::ProductAttribute.where(id: ais).order(input_type: :desc)
  end

  def self.next_categories category_id
    next_categories = self.active.where(parent_id: category_id)
    res = next_categories.blank? ? '' : next_categories.map{|nc| [nc.name, nc.id]}

    return res
  end



end
