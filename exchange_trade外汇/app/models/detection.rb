# ## Schema Information
#
# Table name: `detections` # 发现表
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`table_id(关联表id)`**     | `integer`          |
# **`table_type()`**  | `string(255)`      |
# **`remark(备注)`**  | `text(65535)`      |
# **`active(软删除标志)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `detection_id_name_index`:
#     * **`table_id`**
#     * **`table_type`**
#

class Detection < ApplicationRecord
  belongs_to :table,polymorphic: true
  validates :table_type, inclusion: { in: %w(Article)}
end
