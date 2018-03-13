module Auction::ProductsHelper

  def review_status user
    return 2
  end

  def select_class action_name
    res = ''
    if action_name == 'edit'
      res = 'category_select'
    elsif action_name == 'editor_edit'
      res = 'editor_category_select'
    end
  end

  def pcategory product
    return product.category1&.name.to_s + '-' + product.category2&.name.to_s + '-' + product.category3&.name.to_s
  end

  def change_item_name(type)
    res = ''
    case type
    when 'label'
      res = '标注'
    when 'keywords'
      res = '关键字'
    end

    return res
  end

end
