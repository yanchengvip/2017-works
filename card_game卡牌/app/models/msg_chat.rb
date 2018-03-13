class MsgChat < ApplicationRecord
  self.table_name = 'msg_chat'
  GAME_TYPE = {1 => '平台赛场', 2 => '自建赛场'}
end
