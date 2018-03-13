class UserLoginFirst < ApplicationRecord
  self.table_name = 'user_login_first'

  APP_TYPE = {'ios' => 'ios', 'android' => 'android'}
end
