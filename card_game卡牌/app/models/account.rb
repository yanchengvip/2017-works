class Account < ApplicationRecord
    self.table_name = 'account'
    # establish_connection :drp_pay_database
    establish_connection :drp_database
    belongs_to :user_third_party, class_name: 'UserThirdParty', foreign_key: 'user_id', primary_key: 'user_id'
    has_many :user_third_parties, class_name: 'UserThirdParty', foreign_key: 'user_id', primary_key: 'user_id'
end
