module MallProductsHelper

  def is_exchange_checked type1, type2
    if type1.to_i == 2
      return 'checked'
    end

    if type1.to_i == type2.to_i
      return 'checked'
    end
  end
end
