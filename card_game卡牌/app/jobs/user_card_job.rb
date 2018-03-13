class UserCardJob < ApplicationJob
  queue_as :default

  def perform(user_id, card_id)
    # Do something later
    user = User.where(id: user_id).last
    res = {}
    res = Mammon::Card.use(user, card_id, nil, true) if user
    Rails.logger.info("user:#{user_id}---\r\n#{res}")
  end
end
