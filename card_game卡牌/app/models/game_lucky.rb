class GameLucky < ApplicationRecord

  def self.clear_redis_data
    MsgRecord.apiClient('/card-service-web/gameLuckies/clearGameLuckiesRedis')
  end
end
