# 执行 rails db:article_init
namespace :db do
  task article_init: :environment do
    generate_article
  end
end

def generate_article
  exchange_product1 = ExchangeProduct.create!(symbol: "was", published: true)
  exchange_product2 = ExchangeProduct.create!(symbol: "qw", published: true)
  exchange_product3 = ExchangeProduct.create!(symbol: "wds", published: true)
  exchange_product4 = ExchangeProduct.create!(symbol: "wadsz", published: true)
  exchange_product5 = ExchangeProduct.create!(symbol: "eeew", published: true)
  exchange_product6 = ExchangeProduct.create!(symbol: "dads", published: true)
  exchange_product7 = ExchangeProduct.create!(symbol: "eee", published: true)
  exchange_product8 = ExchangeProduct.create!(symbol: "qqss", published: true)
  exchange_product9 = ExchangeProduct.create!(symbol: "oim", published: true)
  exchange_product10 = ExchangeProduct.create!(symbol: "okjm", published: true)
  exchange_product11 = ExchangeProduct.create!(symbol: "iuhmm", published: true)

  article1 = Article.create!(title: '测试', published_at: Time.now, content: '我说你是人间的四月天', exchange_product_id: exchange_product1.id , article_type: 1, source: "wisdom", rank: "10")
  article2 = Article.create!(title: '测试1', published_at: Time.now, content: '笑响点亮了四面风', exchange_product_id: exchange_product2.id, article_type: 1, source: "wisdom", rank: "11")
  article3 = Article.create!(title: '测试2', published_at: Time.now, content: '在春的光艳中交舞着变', exchange_product_id: exchange_product3.id, article_type: 1, source: "wisdom", rank: "12")
  article4 = Article.create!(title: '测试3', published_at: Time.now, content: '你是四月早天里的云烟', exchange_product_id: exchange_product4.id, article_type: 1, source: "wisdom", rank: "13")
  article5 = Article.create!(title: '测试4', published_at: Time.now, content: '黄昏吹着风的软星子在', exchange_product_id: exchange_product5.id, article_type: 1, source: "wisdom", rank: "14")
  article6 = Article.create!(title: '测试5', published_at: Time.now, content: '百花的冠冕你戴着', exchange_product_id: exchange_product6.id, article_type: 1, source: "wisdom", rank: "15")
  article7 = Article.create!(title: '测试6', published_at: Time.now, content: '水光浮动着你梦期待中白莲', exchange_product_id: exchange_product7.id, article_type: 1, source: "wisdom", rank: "16")
  article8 = Article.create!(title: '测试7', published_at: Time.now, content: '你是一树一树的花开', exchange_product_id: exchange_product8.id, article_type: 1, source: "wisdom", rank: "17")
  article9 = Article.create!(title: '测试8', published_at: Time.now, content: '你是人间的四月天', exchange_product_id: exchange_product9.id, article_type: 1, source: "wisdom", rank: "18")
  article10 = Article.create!(title: '测试9', published_at: Time.now, content: '雪化后那篇鹅黄', exchange_product_id: exchange_product10.id, article_type: 1, source: "wisdom", rank: "19")
  article11 = Article.create!(title: '测试10', published_at: Time.now, content: '你是四月早天里的云烟', exchange_product_id: exchange_product11.id, article_type: 1, source: "wisdom", rank: "20")
end
