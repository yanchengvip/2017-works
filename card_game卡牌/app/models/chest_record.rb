class ChestRecord < ApplicationRecord
  belongs_to :user
  belongs_to :chest_box
  belongs_to :chest_prize, foreign_key: 'big_prize_id'
  has_many :chest_record_pays
  after_create :generate_code
  has_one :jd_card
  belongs_to :address

  has_many :chest_record_items
  include SendVoucherToIhave


  #发货状态
  SHIPSTATUS = {0 => '未发货', 1 => '已发货', 2 => '待支付', 3 => '已支付-待发货', 4 => "到付-待发货"}

  STATUS = {1 => '存在实物奖品未领取', 2 => '已领取', 3 => '存在充值卡奖品未领取', 4 => '已献祭'}

  #type = 0 all,  1 待领取  ， 2代发放， 3 已领取
  def self.get_list(current_user, type, params)
    case type
    when 0 #all
      chest_records = ChestRecord.where(user_id: current_user["id"]).where.not(chest_prize_ids: '', chest_type: [7, 8]).order(id: :desc).page(params[:page] || 1).per(15)
      # total_count = ChestRecord.where(user_id: current_user["id"]).count
    when 1 #待领取
      chest_records = ChestRecord.where("(status in (0, 1, 3) ) or (status = 2 and ship_status = 2)").where(user_id: current_user["id"]).where.not(chest_prize_ids: '', chest_type: [7, 8]).order(id: :desc).page(params[:page] || 1).per(15)
      # total_count = ChestRecord.where("(status in (0, 1, 3) ) or (status = 2 and ship_status = 2)").where(user_id: current_user["id"]).count
    when 2 #代发放
      chest_records = ChestRecord.where("status = 2 and (phonecard_prizes_status = 1 or ship_status = 3 or ship_status = 4)").where(user_id: current_user["id"]).where.not(chest_prize_ids: '', chest_type: [7, 8]).order(id: :desc).page(params[:page] || 1).per(15)
      # total_count = ChestRecord.where("status = 2 and (phonecard_prizes_status = 1 or ship_status = 3)").where(user_id: current_user["id"]).count
    when 3 #已领取
      chest_records = ChestRecord.where("status = 4 or phonecard_prizes_status = 3  or (phonecard_prizes_status = 0 and ship_status = 0 and status = 2)").where.not(chest_prize_ids: '', chest_type: [7, 8]).where(user_id: current_user["id"]).order(id: :desc).page(params[:page] || 1).per(15)
      # total_count =  ChestRecord.where("status = 4 or phonecard_prizes_status = 3 or ship_status = 2 or (phonecard_prizes_status = 0 and ship_status = 0 and status = 2)").where(user_id: current_user["id"]).count
    else
      chest_records = []
    end
    chest_prize_ids = chest_records.map { |x| x.chest_prize_ids.split(",") }.flatten.uniq
    res = []
    chest_records.each do |chest_record|
      res << chest_record.as_json.merge(chest_prizes: ChestPrize.get_prizes_by_ids(chest_record.chest_prize_ids))
    end
    return res
  end

  def init_chest_record_item
    self.chest_prize_ids.split(",").each do |chest_prize_id|
      self.chest_record_items.create!(chest_prize_id: chest_prize_id, user_id: self.user_id, chest_box_id: self.chest_box_id, status: 0, prize_type: ChestPrize.get_prize_by_id(chest_prize_id)["prize_type"])
    end
  end






  private

  def generate_code
    self.update_attributes(code: UUIDTools::UUID.random_create().to_s.gsub("-", ""))
    unless self.chest_prize_ids.blank?
      prizes = ChestPrize.where(id: self.chest_prize_ids.split(","))
      prizes.each do |prize|
        if prize.prize_type == 7
          # ChestOrder.create(code: self.code, recharge_type: 1, status: 0, number: self.user.login_name, amount: prize.num, user_id: self.user_id, chest_record_id: self.id, channel: 0)
          self.phonecard_prizes_status = 1
          self.prize_type = 7
        elsif prize.prize_type == 6
          self.voucher_prizes_status = 1
        elsif prize.prize_type == 1
          self.prize_type = 1
        elsif prize.prize_type == 9
          self.prize_type = 9
        elsif prize.prize_type == 10
          self.prize_type = 10
        end
      end
      self.save
    end
    ChestRecordItemJob.perform_now(self.id)
    ChestOrderVoucherJob.set(wait: 1.seconds).perform_later(self.id)
  end

end
