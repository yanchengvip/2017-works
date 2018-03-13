class ChestRecordItem < ApplicationRecord
  belongs_to :chest_record
  belongs_to :chest_prize
  belongs_to :chest_box
  belongs_to :user
  self.xml_options = {
      :only => ["id", "chest_record_id", "chest_prize_id", "user_id", "chest_box_id", "status", "prize_type", "level", "created_at", "updated_at"].freeze,
      include: {
          chest_prize: {
              only: ["id", "name", "prize_type", "num", "price", "thumbnail", "win_copy", "share_num", "jump_type", "table_id", "table_type", "delete_flag", "created_at", "updated_at", "event_id", "memo", "postage", "t114", "t267", "exchange"]
          },
          chest_box: {
              only: [:chest_type]
          }
      }
  }.freeze


  #宝箱奖品已抽次数
  def self.prize_lottery_num chest_box_id, chest_prize_id
    Rails.cache.fetch("box_prize_lottery_num:#{chest_box_id}-#{chest_prize_id}", expires_in: 60) {
      ChestRecordItem.where(chest_prize_id: chest_prize_id, chest_box_id: chest_box_id).count
    }

  end


  after_create :incrby_redis_count
  after_create :send_red_package
  after_create :add_mammon_card_count

  def incrby_redis_count
    $redis.incrby("chest_record_item_total:#{self.prize_type}:#{self.user_id}", self.chest_prize&.num.to_i)
  end

  def add_mammon_card_count
    if self.prize_type >= 12 && self.prize_type <= 18 #财神卡牌类型
      period = Mammon::Period.current
      num  = ""
      num = case self.prize_type
      when 12
        'danqiang'
      when 13
        "jiahuo"
      when 14
        "xiaohao"
      when 15
        "fanqiang"
      when 16
        "zengfu"
      when 17
        "huhuan"
      when 18
        "qunqiang"
      end
      Rails.logger.info("add_mammon_card_count___#{num}___#{self.prize_type}")
      card_id = Mammon::Card.get_card_by_num(num)["id"]
      user_card = Mammon::UserCard.find_by(:user_id => self.user_id ,:card_id => card_id, :period_id => period.id)
      Mammon::UserCard.add_invite_card user_card, self.user, card_id, period, 1
    end

  end

  def send_red_package
    begin
      chest_box_prize = Rails.cache.fetch("chest_box:#{self.chest_box_id}chest_box_prizes", expires_in: 100){
        self.chest_box.chest_box_prizes.as_json
      }.select{|x| x["chest_prize_id"] == self.chest_prize_id}.first
      red_package_rule_id = chest_box_prize["red_package_rule_id"]
      if red_package_rule_id.to_i > 0
        rule = Promotion::RedPackageRule.find(red_package_rule_id)
        if rule.status == 0
          rule.new_red_package(self, Time.now + rule.open_wait_time, Time.now + rule.open_wait_time + rule.close_wait_time )
        end
      end
    rescue Exception => e

    end
  end

end
