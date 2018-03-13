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

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
