class Auction::User < ApplicationRecord
  belongs_to :level
  belongs_to :account, class_name: Core::Account, foreign_key: 'id'
end
