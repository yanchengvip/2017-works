class AlterCardMrj < ActiveRecord::Migration[5.0]
  def change
    mrj = Card.find_by(code: '100012')
    mrj&.update_attribute(:effect_condition, '100001,100002,100003,100004,100005')
  end
end
