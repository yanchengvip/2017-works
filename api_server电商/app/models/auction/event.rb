class Auction::Event < ApplicationRecord
  self.xml_options = {
    only: [:id, :micro_amount, :pic, :amount, :price],

  }
end
