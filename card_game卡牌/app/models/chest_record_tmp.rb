class ChestRecordTmp < ApplicationRecord
  belongs_to :chest_box

  def to_chest_record current_user
    begin
      if current_user
        self.with_lock do
          if self.status == 0
            chest_record = ChestRecord.create!(chest_box_id: self.chest_box_id, chest_prize_ids: self.chest_prize_ids, user_id: current_user.id, chest_box_open_type: 0)
            if self.chest_box_chest_type == 5
              self.update!(status: 1, user_id: current_user.id)
            else
              chest_record.update!(prize_type: 1)
              self.update!(status: 1)
            end
            return {"execResult"=>true, "execMsg"=>"绑定成功", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"200"}
          else
            return {"execResult"=>false, "execMsg"=>"", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
          end
        end
      else
        return {"execResult"=>false, "execMsg"=>"", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
      end
    rescue Exception => e
      return {"execResult"=>false, "execMsg"=>"", "execData"=>{error: e.as_json}, "execDatas"=>[], "execErrCode"=>"500"}
    end
  end

  def self.overdue_to_redis
    where("mobile = '' and chest_box_chest_type = 6 and created_at < ?", Time.now - 600).map(&:overdue_to_redis)
  end

  def overdue_to_redis
    self.with_lock do
      if self.status == 0 && self.created_at < (Time.now - 600) && self.chest_box.chest_type == 6
        self.update(status: -1)
        redis_key = self.chest_box.jd_card_redis_key(self.draw_type)
        $redis.lpush(redis_key, self.chest_prize_ids)
      end
    end
  end

  def self.syn!
    where("status = 0 and mobile <> ''").each do |x|
      user = User.where(login_name: x.mobile).first
      x.to_chest_record(user) if user
    end

  end

  def overdue_to_db
    begin
      self.with_lock do
        if self.status == 0 && self.created_at < (Time.now - 24 * 3600 * 3) && self.chest_box.chest_type == 5
          self.update!(status: -1)
          self.chest_prize_ids.split(",").each do |chest_prize_id|
            prize =  self.chest_box.chest_box_prizes.where(chest_prize_id: chest_prize_id).order(created_at: :desc).limit(1).lock(true).first
            prize.update!(left_num: prize.left_num.to_i + 1)
          end
        end
      end
    rescue Exception => e
      Rails.logger.info(e.as_json)
    end
  end

end
