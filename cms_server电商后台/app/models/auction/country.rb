class Auction::Country < ApplicationRecord

  scope :published, -> { where(published: true)}
end
