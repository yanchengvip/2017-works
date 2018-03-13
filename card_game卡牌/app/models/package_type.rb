class PackageType < ApplicationRecord
  has_many :packages

  validates :name, presence: true
  validates :name, uniqueness: { scope: :delete_flag, message: "分类名称不能重复"}
end
