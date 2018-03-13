class InitTradeJob < ApplicationJob
  queue_as :default

  def perform(auction_trade, unit_ids)
    # p auction_trade
    ActiveRecord::Base.transaction do
      st = Supplier::Trade.create(auction_trade)
      Auction::Unit.where(id: unit_ids).update_all(supplier_trade_id: st.id)
    end
    # auction_trade.units.update_all supplier_trade_id: st.id
    # Do something later
  end
end
