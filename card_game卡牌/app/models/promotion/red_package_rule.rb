class Promotion::RedPackageRule < ApplicationRecord
  has_many :red_package_rule_items, -> { where(delete_flag: false) }
  belongs_to :admin
  has_many :red_packages
  belongs_to :chest_prize, class_name: 'ChestPrize', foreign_key: 'chest_prize_id'
  has_many :red_package_records

  STATUS = {0 => '启用', 1 => '禁用'}

  def save_items! item_params, voucher_item_params, bxf_item_params
    unless self.new_record?
      self.red_package_rule_items.update_all(delete_flag: true)
    end
    # total_amount = 0
    [item_params, voucher_item_params, bxf_item_params].each do |params|
      params && params.each do |param|
        rule_item = self.red_package_rule_items.create!(param.permit!.slice('prize_type', 'count', 'chest_prize_id'))
        # total_amount += param['amount'].to_f * param['count'].to_i
      end
    end
    # self.update_attributes!(total_amount: total_amount)
  end

  def update_total! amount
    self.update_attributes!(total_amount: self.total_amount - amount)
  end

  def new_red_package(record, begin_time, end_time)

      r = Promotion::RedPackage.order(begin_time: :desc).lock(true).first

      record_user_id = case record.class.to_s
      when "ChestRecordItem"
        record.user_id
      when "GameLeague"
        record.champion_id
      else
        0
      end
      begin
        msg =  self.content.gsub("{user_name}", User.where(id: record_user_id).first&.nick_name.to_s)
      rescue Exception => e
        msg = ""
      end


      if r && r.begin_time + 120 > begin_time
        red_package = self.red_packages.create!(table_type: record.class.to_s, table_id: record.id, begin_time: r.begin_time + 120, end_time: end_time + ((r.begin_time + 120) - begin_time), status: 1, content: msg)
      else
        red_package = self.red_packages.create!(table_type: record.class.to_s, table_id: record.id, begin_time: begin_time, end_time: end_time, status: 1, content: msg)
      end


    red_package.init_redis


    # begin
    #   red_package.update!(content: self.content.gsub("{user_name}", User.where(id: record_user_id).first&.nick_name.to_s))
    # rescue Exception => e
    # end


    # body = self.content.gsub("{user_name}", User.where(id: record_user_id).first&.name.to_s)
    # ChestBox.send_msg(body, body)
    if record.class.to_s != "GameLeague"
      res = MsgRecord.push_msg(SYSTEMCONFIG['java_redis_url'], "/card-service-web/admin/treasureMsgPush", {beginTime: red_package.begin_time, beginTimeStamp: red_package.begin_time.to_i, redPackageId: red_package.id, content: msg, boxName: "红包雨"})
      Rails.logger.info("/card-service-web/admin/treasureMsgPush\r\n#{res}")
    end
    red_package
  end

  def self.auto_trigger_red_package!
    auto_rules = self.active.where(is_auto: true, status: 0)
    auto_rules && auto_rules.each do |rule|
      if rule.begin_time && rule.begin_time.to_time <= Time.now
        record = Promotion::RedPackageRecord.where("red_package_rule_id = ? and day = ?", rule.id, Date.today.to_s).first

        unless record
          begin
            ActiveRecord::Base.transaction do
              record = rule.red_package_records.create!(day: Date.today.to_s, memo: '自动触发')
              rule.new_red_package(record, Time.now + rule.open_wait_time, Time.now + rule.open_wait_time + rule.close_wait_time)
            end
          rescue Exception => e
            nil
          end
        end
      end
    end
  end


end
