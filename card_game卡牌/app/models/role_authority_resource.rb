class RoleAuthorityResource < ApplicationRecord
  validates :role_id, :authority_resource_id, presence: true

  belongs_to :role
  belongs_to :authority_resource
end