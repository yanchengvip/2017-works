class Auction::TradeStatusLog < ApplicationRecord
  belongs_to :table, polymorphic: true
end
