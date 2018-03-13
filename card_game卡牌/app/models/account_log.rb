class AccountLog < ApplicationRecord
    self.table_name = 'account_log'
    # establish_connection :drp_pay_database
    establish_connection :drp_database
    self.inheritance_column = ""
    Channel = {1 => '优众', 2 => '大富翁'}
    ChangeType  = {1 => '增加', 2 => '消费减少', 3 => '退款减少' }
    belongs_to :drp_user, class_name: 'DrpUser', foreign_key: 'user_id'
    belongs_to :user_third_party, class_name: 'UserThirdParty', foreign_key: 'user_id', primary_key: 'user_id'
    include UserDataHelper
    include DownloadCsv
end
