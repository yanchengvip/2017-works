namespace :sync  do
  task product_sync:  :environment do
    sync_mall_product
  end
end

def sync_mall_product
  MallProduct.where(delete_flag: false).find_each do |mp|
    bp = BattleProduct.new(name: mp.name, market_price: mp.market_price, postage: mp.postage, inventory_count: mp.inventory_count, thumbnail: mp.thumbnail, desc: mp.desc, is_mall_product: true, sort: mp.sort, mall_product_tag_ids: '1')

    if mp.micro_score.present? && mp.micro_score > 0
      bp.score_exchange = true
      bp.score = mp.micro_score
    end

    if mp.sku.blank? || BattleProduct.find_by(sku: mp.sku).blank?
      bp.sku = mp.sku
    else
      bp.sku = mp.sku + '_mp'
    end

    if bp.save
      imgs = mp.images
      imgs && imgs.each do |image|
        bp.images.create(url: image.url)
      end
    end
  end
end
