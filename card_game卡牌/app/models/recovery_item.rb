class RecoveryItem < ApplicationRecord
  belongs_to :user
  belongs_to :recovery
end
