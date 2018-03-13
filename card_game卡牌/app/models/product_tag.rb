class ProductTag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  STATUS = {0 => '启用', 1 => '禁用'}
end
