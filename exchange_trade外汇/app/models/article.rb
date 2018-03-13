# ## Schema Information
#
# Table name: `articles` # 新闻
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id()`**                 | `integer`          | `not null, primary key`
# **`title(标题)`**            | `string(255)`      |
# **`published_at(发布时间)`**   | `datetime`         |
# **`content(内容)`**          | `text(65535)`      |
# **`active(软删)`**           | `boolean`          | `default(TRUE)`
# **`published(是否发布)`**      | `boolean`          | `default(FALSE)`
# **`from_url(抓取地址)`**       | `text(65535)`      |
# **`img(大图)`**              | `text(65535)`      |
# **`created_at()`**         | `datetime`         | `not null`
# **`updated_at()`**         | `datetime`         | `not null`
# **`exchange_product_id(外汇品种id)`**        | `integer`          |
# **`article_type(文章类型,1:普通新闻)`**      | `integer`          | `default(0)`
# **`read_num(阅读量)`**        | `integer`          | `default(0)`
# **`rank(排序)`**             | `integer`          | `default(0)`
# **`source(来源，wisdom,新浪，微博等)`**     | `string(255)`      |
# **`likes_count(点赞数)`**     | `integer`          | `default(0)`
#

class Article < ApplicationRecord
  after_create :entry_detection
  def self.crawler_from_wisdom
    list_url =  "http://www.wisfx.com/List.html?page="
    page = 1
    conn = Faraday.new
    flag =  true
    while(flag)
      doc = Nokogiri::HTML(conn.get(list_url + page.to_s).body)
      doc.css(".t4 a").each do |a|
        article = Article.get_detail_data("http://www.wisfx.com/" + a.attributes["href"].text)
        Article.create(article)
      end
      page += 1
      if(doc.css(".t4 a").size < 4)
        flag = false
      end
    end
  end

  def self.get_detail_data(url)
    doc = Nokogiri::HTML(Faraday.new.get(url).body)
    {title: doc.css(".t5").text, content: doc.css(".c2").to_html, published_at: doc.css(".dt3").text, active: true, from_url: url, img: "http://www.wisfx.com/" + doc.css(".im5 img").first.attributes["src"].text}
  end


  # mt5
  def self.crawler_from_mt5(today = true)
    list_url = today ? "https://www.mt5.com/cn/prime_news/index/0/0/today" : "https://www.mt5.com/cn/prime_news/"
    conn = Faraday.new
    doc = Nokogiri::HTML(conn.get(list_url).body)
    new_doc = doc.css('.prime-news-container .prime-news-item a')
    new_doc.each do |ndoc|
      article = Article.get_detail_data_mt5(ndoc.attributes["href"].text)
      unless Article.select('id').find_by(from_url: article[:from_url])
        Article.create(article)
      end
    end
  end

  def self.get_detail_data_mt5(url)
    doc = Nokogiri::HTML(Faraday.new.get(url).body)
    new_doc = doc.css('#text-block-ins')
    {title: new_doc.css('h2').text, content: new_doc.css('#news-text').to_html, published_at: new_doc.css('.sharing div')[0].text.to_time, active: true, from_url: url, img: new_doc.css('.prime-news-new-icon img').first.attributes['src'].text}
  end



  self.xml_options = {
    :only => ["id", "title", "content", "published_at", "img", "exchange_product_id",  "created_at"] .freeze
  }

  def entry_detection
    Detection.create(:table_id => self.id, :table_type => "Article")
  end

end
