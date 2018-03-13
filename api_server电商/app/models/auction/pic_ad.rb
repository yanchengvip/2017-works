class Auction::PicAd < ApplicationRecord
  belongs_to :auction_theme, foreign_key: "link_url", class_name: "Auction::Theme"
  # def is_theme
  # end
end
