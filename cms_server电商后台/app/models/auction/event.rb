class Auction::Event < ApplicationRecord
  CLIENTS = {'app' => 'app', 'all' => '全部'}
  ISSELL = {false => '否', true => '是'}
end
