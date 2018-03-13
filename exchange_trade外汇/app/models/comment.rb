# ## Schema Information
#
# Table name: `comments` # 评论表
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`user_id(用户id)`**  | `integer`          |
# **`content(内容)`**  | `text(65535)`      |
# **`status(1:审核中,2:审核通过3：审核失败)`**               | `integer`          | `default(1)`
# **`request_ip(发布ip)`**     | `string(255)`      |
# **`table_id(关联表id)`**    | `integer`          |
# **`table_type()`**  | `string(255)`      |
# **`active(软删除标志)`**  | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
# **`likes_count(点赞数)`**     | `integer`          | `default(0)`
#
# ### Indexes
#
# * `index_comments_on_user_id`:
#     * **`user_id`**
#

class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :table,polymorphic: true
  validates :table_type, inclusion: { in: %w(Article)}

  self.xml_options = {
    :only => ["id", "user_id", "content", "status", "request_ip",  "created_at"] .freeze,
    :include => {
      :user => { :only => ["id", "nickname", "headimgurl", ]}
    }
  }
end
