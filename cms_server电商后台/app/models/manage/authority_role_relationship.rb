class Manage::AuthorityRoleRelationship < ApplicationRecord
  belongs_to :authority
  belongs_to :role
end
