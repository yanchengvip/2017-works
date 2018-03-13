class Core::Account < ApplicationRecord
  has_many :trades,foreign_key: :user_id, :class_name => 'Auction::Trade'
end
