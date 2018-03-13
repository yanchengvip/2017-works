module EnergyProductsHelper

  def shelf_status(energy_product)
    case energy_product.status
    when -1
      res = '已下架'
    when 0
      res = '未上架'
    when 1
      res = '已上架'
    else
      res = ''
    end
    return res
  end




end
