class Mt4::Trade < ApplicationRecord

  #交易类型
  CMD = {0 => 'BUY', 1 => 'SELL', 2 => 'BuyLimit', 3 => 'SellLimit', 4 => 'BuyStop', 5 => 'SellStop'}
end
