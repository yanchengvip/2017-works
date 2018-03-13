class AddIndexToTrades < ActiveRecord::Migration[5.1]
  def change
    add_index :supplier_trades, [:user_id], name: "supplier_trades_user_id"
    add_index :supplier_trades, [:auction_trade_id, :user_id], name: "supplier_trades_auction_trade_id_user_id"
    add_index :auction_units, [:supplier_trade_id], name: "auction_units_supplier_trade_id"
    add_index :auction_units, [:trade_id], name: "auction_units_trade_id"
  end
end
