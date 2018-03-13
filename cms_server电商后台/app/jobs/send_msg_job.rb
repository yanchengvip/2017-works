class SendMsgJob < ApplicationJob
  queue_as :default

  def perform(phones, content)
    phones && phones.each do |phone|
      Auction::Sm.create(phone: phone, content: content)
    end
  end

end
