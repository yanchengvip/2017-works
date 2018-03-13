#挂单交易任务
class PendingTradesJob < ApplicationJob
  queue_as :pending_trades


  def perform(trade_id)
    trade = Virtual::Trade.active.find_by(id: trade_id)
    res = trade.pending_trade_by_job
    unless res
      PendingTradesJob.set(wait: 5.seconds).perform_later(trade_id)
    end
  end
end
