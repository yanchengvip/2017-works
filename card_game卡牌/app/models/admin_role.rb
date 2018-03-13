class AdminRole < ApplicationRecord

  belongs_to :admin
  belongs_to :role

  validates_uniqueness_of :admin_id, scope: [:role_id, :delete_flag]

end
