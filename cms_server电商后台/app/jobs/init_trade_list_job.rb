class InitTradeListJob < ApplicationJob
  queue_as :default

  def perform(params)
    Auction::TradeList.create(params)
  end
end
