namespace :init_database do
  desc "初始化数据"
  task init: :environment do
    # create_uz_provider
  end

#1 rake init_database:create_uz_provider                            # 创建优众自营供应商

#2 rake init_database:create_sku                                    # 初始化SKU数据表

#3 rake init_database:create_provider_trade                         # 拆分优众老订单

#4 rake init_database:create_unit_info                              # 初始化UNIT product_id 值 必须先执行 create_sku

#7 rake init_database:create_manage_authority                       # 权限控制表初始化

#5 rake init_database:import_supplier_product_from_auction_product  # 优众商品导入供应商商品


#6 rake init_database:init_user_default_contact                     # 初始化默认地址

#7 rake init_database:init_auction_trade_list_data                     # 初始化订单索引列表

  desc "创建优众自营供应商"
  task create_uz_provider: :environment do
    Supplier::Provider.delete_all
    Supplier::Provider.create(name: "优众自营", description: "优众自营", active: true, login: "admin@ihaveu.net", password: "admin123",)
  end

  desc "初始化SKU数据表"
  task create_sku: :environment do
    _t = Time.now
    provider_id = Supplier::Provider.first&.id
    skus = Hash.new
    Auction::Item.order(id: :asc).find_each do |item|
      if item.trade_id.blank?
        skus[item.product_id] ||= Hash.new 0
        skus[item.product_id][item.measure] += 1
      else
        skus[item.product_id] ||= Hash.new 0
        skus[item.product_id][item.measure] += 0
      end
    end
    Auction::Sku.delete_all
    skus.each do |p_id, data|
      data.each do |measure, amount|
        InitSkuJob.set(wait: 1.seconds).perform_later(product_id: p_id, active: true, name: (measure.blank? ? "默认" : measure), amount: amount, code: "", provider_id: provider_id)
        # Auction::Sku.create(product_id: p_id, active: true, name: measure, amount: amount, code: "", provider_id: provider_id)
      end
    end
    p "初始化SKU数据表完成"
    f = File.open("init_database.log", "a+")
    f.write("create_sku#{Time.now - _t}\n")
    f.close
  end

  desc "初始化UNIT product_id 值 必须先执行 create_sku"
  task create_unit_info: :environment do
    _t = Time.now
    csv_data = read_csv_data
    # csv_data = {}
    provider_id = Supplier::Provider.first&.id
    Auction::Unit.includes(:item).find_each do |unit|
      auction_product_id = unit.item.product_id
      sku_name = unit.item.measure
      sku_name = sku_name.blank? ? "默认" : sku_name
      amount = 1
      InitUnitJob.set(wait: 1.seconds).perform_later(unit.id, auction_product_id, sku_name, provider_id, amount, csv_data["'#{unit.item.identifer}"].try("导入采购价(自采商品为成本)实库代销暂未换算为成本").to_f)
      # auction_sku_id = Auction::Sku.where(product_id: auction_product_id, name: sku_name).first&.id
      # unit.update(auction_product_id: auction_product_id, amount: amount, auction_sku_id: auction_sku_id, sku_name: sku_name, provider_id: provider_id)
    end
    p "初始化UNIT product_id 值 必须先执行 create_sku 完成"
    f = File.open("init_database.log", "a+")
    f.write("create_unit_info#{Time.now - _t}\n")
    f.close
  end


  def read_csv_data
    key = nil
    res = {}
    File.readlines("xq-20170930-ut8.csv").each do |x|
      # File.readlines("test.csv").each do |x|
      x = x.split(",")
      if key.blank?
        key = x
      else
        tmp={}
        key.each_with_index do |k, index|
          tmp[k] = x[index]
        end
        res[x.first] = tmp
      end
    end
    res
  end


  desc "优众商品导入供应商商品"
  task import_supplier_product_from_auction_product: :environment do
    _t = Time.now
    provider_id = Supplier::Provider.active.first&.id
    Auction::Product.update_all(provider_id: provider_id)
    Auction::Product.select("id", "name", "description", "price", "discount", "spec_pic", "color_pic", "color_name", "identifier", "keywords", "relate_product_ids", "category1_id", "category2_id", "brand_id", "published_at", "target", "match_product_ids", "major_pic", "remark", "label", "prefix", "category3_id", "remark2", "foreign_payment", "keywords2", "use_voucher", "percent", "created_at", "updated_at", "published", "status").order(id: :asc).find_each do |auction_product|
      InitSupplierProductJob.set(wait: 1.seconds).perform_later(auction_product.attributes.merge("provider_price": 0, "provider_id": provider_id).as_json)
      # Supplier::Product.create(auction_product.attributes.merge("provider_price": 0, "provider_id": provider_id))
    end
    p "优众商品导入供应商商品完成"
    f = File.open("init_database.log", "a+")
    f.write("import_supplier_product_from_auction_product#{Time.now - _t}\n")
    f.close
  end

  desc "拆分优众老订单"
  task create_provider_trade: :environment do
    _t = Time.now
    provider_id = Supplier::Provider.active.first&.id
    Auction::Trade.includes(:units).select("id", "status", "price", "payment_price", "tax_price", "active", "delivery_service", "delivery_identifier", "ship_at", "remark", "delivery_phone", "balance_price", "created_at", "updated_at", "user_id").order(id: :asc).find_each do |auction_trade|
      InitTradeJob.set(wait: 1.seconds).perform_later(auction_trade.attributes.merge(auction_trade_id: auction_trade.id, provider_id: provider_id).as_json, auction_trade.units.pluck(:id))
      # st = Supplier::Trade.create(auction_trade.attributes.merge(auction_trade_id: auction_trade.id, provider_id: provider_id))
      # auction_trade.units.update_all supplier_trade_id: st.id
    end
    p "拆分优众老订单完成"
    f = File.open("init_database.log", "a+")
    f.write("create_provider_trade#{Time.now - _t}\n")
    f.close
  end

  desc "权限控制表初始化"
  task create_manage_authority: :environment do
    _t = Time.now
    Manage::Authority.delete_all
    Manage::Role.delete_all
    system "rake routes > routes.txt"
    File.readlines("routes.txt").each_with_index do |data, index|
      next if index == 0
      begin
        action = data.split(" ").last
        action_name = I18n.t("routes.action.#{action.split('#').first}.#{action.split('#').last}")
        action_name = I18n.t("helpers.#{action.split('#').last}") if !!action_name.match("translation missing:")
        action_name = action.split('#').last if !!action_name.match("translation missing:")
        resource_name = I18n.t("routes.controller.#{action.split('#').first}")
        resource_name = action.split('#').first if !!resource_name.match("translation missing:")

        name = resource_name + "-" + action_name
        # name = action if !!name.match("translation missing:")
        # p "#{action}-#{name}\n" unless !!action.match(/^supplier/) || !!action.match(/^sessions/)
        Manage::Authority.create(name: name, action: action, active: true) unless !!action.match(/^supplier/) || !!action.match(/^sessions/)
      rescue Exception => e
      end
    end
    role = Manage::Role.create(name: "admin", active: true)
    role.authorities << Manage::Authority.all
    editor = Manage::Editor.where(email: "admin@ihaveu.net", active: true).first || Manage::Editor.create(name: "admin", active: true, department: "产品技术部", identifier: "admin", email: "admin@ihaveu.net", password: "admin123")
    editor.roles << role
    p "权限控制表初始化完成"
    f = File.open("init_database.log", "a+")
    f.write("create_manage_authority#{Time.now - _t}\n")
    f.close
  end


  desc "初始化默认地址"
  task init_user_default_contact: :environment do
    _t = Time.now
    # Auction::User.order(id: :asc).find_each do |user|
    #   if user.default_contact_id && user.default_contact_id > 0
    #     Auction::Contact.where(id: user.default_contact_id).update(is_default: true)
    #   end
    # end
    Auction::User.where("default_contact_id is not null").pluck(:default_contact_id).uniq.each_slice(1000).to_a.each do |ids|
      Auction::Contact.active.where(id: ids).update_all(is_default: true)
    end
    p "初始化默认地址完成"
    f = File.open("init_database.log", "a+")
    f.write("init_user_default_contact#{Time.now - _t}\n")
    f.close
  end

  desc "初始化购物车数据"
  task init_retail_carts: :environment do
    skus = Auction::Sku.all.group_by { |x| x.product_id }
    Retail::Cart.order(id: :asc).find_each do |cart|
      if skus[cart.product_id]
        sku_id = skus[cart.product_id].select { |x| x.name == (cart.measure.blank? ? "默认" : cart.measure) }.first&.id.to_i
      else
        sku_id = 0
      end
      InitCartJob.set(wait: 1.seconds).perform_later(cart.id, cart.product_id, cart.measure.blank? ? "默认" : cart.measure, sku_id)
    end
  end

  desc "复制供应商数据"
  task init_supplier_provider_data: :environment do
    create_supplier_provider
  end


  desc "建立订单索引数据"
  task init_auction_trade_list_data: :environment do
    Auction::Trade.includes(:supplier_trades,:account).all.each do |trade|
      if trade.supplier_trades.present?
        InitTradeListJob.perform_later({auction_trade_id: trade.id,created_at: trade.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                                        status: 2,identifier: trade.identifier,user_id: trade.user_id,contact_id: trade.contact_id})
      else
        InitTradeListJob.perform_later({auction_trade_id: trade.id, created_at: trade.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                                        status: 1,identifier: trade.identifier,user_id: trade.user_id,contact_id: trade.contact_id})
      end

    end
    Supplier::Trade.includes(:contact).all.each do |t|
      InitTradeListJob.perform_later({auction_trade_id: t.auction_trade_id,supplier_trade_id: t.id,
                                      created_at: t.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                                      status: 3,identifier: t.identifier,user_id: t.user_id,contact_id: t.contact&.id})
    end
  end

  def create_supplier_provider
    data = read_csv_data
    res = []
    data.each do |key, value|
      if value["供应商自行管理货品"] == '根据仓库判定' && value["仓库分类"] == '虚拟仓'
        res << value
      end
    end
    products = {}
    supplier = {}
    res.each do |x|
      if supplier[x["供应商"]].blank?
        unless s = Supplier::Provider.where(name: x["供应商"]).first
          s = Supplier::Provider.create(name: x["供应商"], login: Digest::SHA1.hexdigest(x["供应商"])+ "@ihaveu.net", description: x["供应商"], active: true, is_cod: true, partner_type: partner_type(x["合作模式"]), invoice_type: invoice_type(x["发票类型"]), is_direct_ship: true, gross_margin: 0.15, active_gross_margin: 0.1)
        end
        supplier[x["供应商"]] = s.id
      end
      if products[x["产品ID"]].blank?
        products[x["产品ID"]] = 1
        CopyProductJob.set(wait: 1.seconds).perform_later(supplier[x["供应商"]], x["产品ID"])
      end
      # copy_product supplier[x["供应商"]], x["产品ID"]
    end
  end

  def copy_product provider_id, product_id
    if product = Supplier::Product.where(id: product_id).first
      json = product.as_json.merge(provider_id: provider_id)
      json.delete("id")
      copy_product = Supplier::Product.create(json)
      sku_json = product.skus.select(:name, :amount, :code).as_json
      sku_json.map { |x| x.delete("id") }
      copy_product.skus.create(product.skus.select(:name, :amount, :code).as_json)
      copy_product.images.create product.images.select(:large, :user_id, :active, :description).as_json
      copy_product.values.create product.values.select(:editor_id, :attribute_id, :content, :active, :attribute_name).as_json
    end
  end

  def invoice_type invoice
    case invoice
      when "1"
        1
      when "1.03"
        2
      when "1.11"
        3
      when "1.17"
        4
      else
        0
    end

  end

  def partner_type string
    case string
      when "平台供应商"
        1
      when "代销供应商"
        2
      when "平台兼代销供应商"
        3
      else
        0
    end
  end

end
