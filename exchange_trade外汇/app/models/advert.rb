# ## Schema Information
#
# Table name: `adverts` # 广告表
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id()`**          | `integer`          | `not null, primary key`
# **`title(标题)`**     | `string(255)`      |
# **`advert_type(类型;0:无，1:首页轮播,2:启动图)`**                    | `integer`          | `default(0)`
# **`img(图片)`**       | `text(65535)`      |
# **`from_url(来源地址)`**  | `text(65535)`      |
# **`rank(排序)`**      | `integer`          | `default(0)`
# **`remark(备注)`**    | `text(65535)`      |
# **`published(是否发布)`**   | `boolean`          | `default(FALSE)`
# **`published_at(发布时间)`**      | `datetime`         |
# **`active(软删)`**    | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#

class Advert < ApplicationRecord
end
