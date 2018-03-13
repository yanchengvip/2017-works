class Auction::ApplyLog < ApplicationRecord
  belongs_to :editor, class_name: 'Manage::Editor', foreign_key: 'user_id'
end
