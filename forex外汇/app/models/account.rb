class Account < ApplicationRecord
  belongs_to :dealer
  has_many :account_traders, foreign_key: 'account_id'
  has_many :virtual_trades, class_name: 'Virtual::Trade', foreign_key: :account_id
  has_many :mt4_trades, class_name: 'Mt4::Trade', foreign_key: :account_id
end