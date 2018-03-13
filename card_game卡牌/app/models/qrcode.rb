class Qrcode < ApplicationRecord
  validates :name, uniqueness: true, presence: true

end