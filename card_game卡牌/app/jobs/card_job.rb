class CardJob < ApplicationJob
  queue_as :default

  def perform(to_user_id, current_user_id, period_id, user_card_id)
    # Do something later
    begin
      current_user = User.find(current_user_id)
      period = Mammon::Period.find(period_id)
      user_card = Mammon::UserCard.find user_card_id
      Mammon::Card.danqiang_action to_user_id, current_user, period, user_card
    rescue Exception => e

    end

  end
end
