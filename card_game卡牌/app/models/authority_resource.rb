class AuthorityResource < ApplicationRecord
  STATUS = {1 => '启用', 2 => '禁用'}
  validates :name, uniqueness: { scope: [:delete_flag], message: "name不能重复" }, presence: true
  validates :model_n, uniqueness: { scope: [:action_n,:delete_flag], message: "model_n和action_n不能重复" }
  has_many :role_authority_resources,dependent: :destroy
end