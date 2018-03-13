class BoxPrizeCode < ApplicationRecord
  belongs_to :box_prize
  has_many :box_prize_records
  after_create :generate_code
  validates :code,  uniqueness: true

  def generate_code
    code = (MyUtils.generate_uuid.delete('-') + self.id.to_s).last(16)
    self.update_attributes(code: code)
  end


  #下载兑换码记录csv
  def self.to_csv_for_codes box_prize_id
    require 'csv'
    box_prize = BoxPrize.find(box_prize_id)
    #独立兑奖码
    return once_code_csv box_prize_id if box_prize.prize_type == 1
    #复用兑奖码
    return reuse_code_csv box_prize_id if box_prize.prize_type == 2

  end



  #兑换
  def exchange_price_code current_user
    bpc = BoxPrizeCode.find(self.id)
    bpc.with_lock do
      use_num = bpc.use_num.to_i + 1
      if use_num > bpc.num.to_i
        return  {execResult: true, execMsg: '兑换码数量已使用完', execErrCode: 406, execDatas: []}
      end
      bpc.update_attributes!(use_num: use_num)
      #赠送付费宝箱符
      if self.box_prize&.treasure_type == 1
        treasure_amount = self.box_prize.treasure_amount.to_i
        bpc.box_prize_records.create!(user_id: current_user.id, box_prize_id: self.box_prize.id,
                                      code: bpc.code, treasure_amount: treasure_amount)
        current_user.account_ticket.lock!.update!(treasure_total_amount: current_user.account_ticket.treasure_total_amount + treasure_amount)
        current_user.account_ticket.account_ticket_details.create!(user_id: current_user.id, type: AccountTicketDetail::DETAILTYPE["宝箱宝符"], fund: treasure_amount, wealth_type: 2, trad_type: AccountTicketDetail::TRADTYPE["兑换码兑换"], create_time: Time.now)

      end

      #赠送免费宝箱符
      if self.box_prize&.treasure_type == 2
        free_treasure_amount = self.box_prize.free_treasure_amount.to_i
        bpc.box_prize_records.create!(user_id: current_user.id, box_prize_id: self.box_prize.id,
                                      code: bpc.code, free_treasure_amount: free_treasure_amount)
        current_user.account_ticket.lock!.update!(free_treasure_amount: current_user.account_ticket.free_treasure_amount + free_treasure_amount)
        current_user.account_ticket.account_ticket_details.create!(user_id: current_user.id, type: AccountTicketDetail::DETAILTYPE["免费宝箱宝符"], fund: free_treasure_amount, wealth_type: 2, trad_type: AccountTicketDetail::TRADTYPE["兑换码兑换"], create_time: Time.now)
      end

    end

    return {execResult: true, execMsg: '兑换码数量已使用完', execErrCode: 200, execDatas: []}

  end


  private

  #独立兑奖码
  def self.once_code_csv box_prize_id
    all_num = BoxPrizeCode.where(box_prize_id: box_prize_id).count
    use_num = BoxPrizeCode.where(box_prize_id: box_prize_id).where.not(use_num: 0).count
    not_use = BoxPrizeCode.where(box_prize_id: box_prize_id, use_num: 0)
    header1 = ["\xEF\xBB\xBF生成数量", all_num, "已用数量", use_num, ""]
    header2 = ["兑奖码", "手机号", "使用ID", "注册时间", "用户昵称"]
    bprs = BoxPrizeRecord.includes(:user, :box_prize).where(box_prize_id: box_prize_id)
    CSV.generate do |csv|
      csv << header1
      csv << header2 #这是文件的headers
      bprs.each do |bpr|
        csv << [bpr.code, bpr.user&.mobile, bpr.user&.id, bpr.user&.create_time.strftime('%Y-%d-%m %H:%M'), bpr.user&.nick_name] #数据内容
      end
      not_use.each do |nu|
        csv << [nu.code, '', '', '', ''] #数据内容
      end
    end
  end

  #复用兑奖码
  def self.reuse_code_csv box_prize_id
    bpc = BoxPrizeCode.where(box_prize_id: box_prize_id).first
    all_num = bpc&.num
    use_num = bpc&.use_num
    header1 = ["\xEF\xBB\xBF兑奖码:", bpc&.code, "生成数量:", all_num, "已用数量:", use_num]
    header2 = ["手机号", "使用ID", "注册时间", "用户昵称"]
    bprs = BoxPrizeRecord.includes(:user, :box_prize).where(box_prize_id: box_prize_id)
    CSV.generate do |csv|
      csv << header1
      csv << header2 #这是文件的headers
      bprs.each do |bpr|
        csv << [bpr.code, bpr.user&.mobile, bpr.user&.id, bpr.user&.create_time.strftime('%Y-%d-%m %H:%M'), bpr.user&.nick_name] #数据内容
      end
    end
  end


end
