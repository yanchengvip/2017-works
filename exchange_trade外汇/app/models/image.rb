# ## Schema Information
#
# Table name: `images` # 图片表
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`name(图片名称)`**  | `string(255)`      |
# **`url(图片地址)`**   | `string(255)`      |
# **`table_id(所属表id)`**     | `integer`          |
# **`table_type(所属表名)`**      | `string(255)`      |
# **`remark(备注)`**  | `text(65535)`      |
# **`active(软删除标志)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `image_id_type_index`:
#     * **`table_id`**
#     * **`table_type`**
#

class Image < ApplicationRecord
end
