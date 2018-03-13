module Supplier::ProductsHelper
  # 属性
  def is_selected_atr values, atr, ol
    values && values.each do |value|
      return 'selected' if value.attribute_id == atr.id && value.content == ol
    end
  end

  def selected_atr_str values, atr
    res = []
    atr.option_list.split.each do |ol|
      values && values.each do |value|
        res << value.attribute_name if value.attribute_id == atr.id && value.content == ol
      end
    end
    return res
  end

  def product_status_txt supplier_product
    res = '已下架'
    if supplier_product.published
      res = '上架中'
    elsif !supplier_product.status.in? [0, 5]
      res = '审核中'
    elsif supplier_product.status == 0
      res = '未提交审核'
    elsif supplier_product.status == 5
      res = '已下架'
    end

    return res
  end

  def select_class action_name
    res = ''
    if action_name == 'edit' || action_name == 'new'
      res = 'category_select'
    elsif action_name == 'editor_edit'
      res = 'editor_category_select'
    end
    return res
  end

end
