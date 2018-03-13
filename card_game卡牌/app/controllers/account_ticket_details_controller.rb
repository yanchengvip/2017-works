require 'csv'
class AccountTicketDetailsController < ApplicationController
  before_action :side_menus10
  def index
  end


  def treasure_amount
    relation = AccountTicketDetail.where(type: 3).includes(:user).active
    relation = relation.joins("left join user on user.id = account_ticket_detail.user_id").where("user.mobile = ?", params[:mobile]) unless params[:mobile].blank?
    @q = relation.ransack(params[:q])
    @account_ticket_details = @q.result.page(params[:page]).per(15)
    if request.format.symbol == :csv
      trad_type = AccountTicketDetail::TRADTYPE.to_a.map{|x| x.reverse}.to_h
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 手机号 交易时间 交易数量 交易状态 交易类型)
        @q.result.each do |account_ticket_detail|
          csv << [account_ticket_detail.user_id, account_ticket_detail.user&.mobile, account_ticket_detail.create_time, account_ticket_detail.fund, AccountTicketDetail::WEALTHTYPE[account_ticket_detail.wealth_type] || account_ticket_detail.wealth_type, trad_type[account_ticket_detail.trad_type] || account_ticket_detail.trad_type ]
        end
      end
    end
    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  #开启机会明细
  def open_ticket_list
      relation = AccountTicketDetail.where(type: 4).includes(:user).active
      relation = relation.joins("left join user on user.id = account_ticket_detail.user_id").where("user.mobile = ?", params[:mobile]) unless params[:mobile].blank?

      @q = relation.ransack(params[:q]).result
      @ticket_details = @q.page(params[:page]).per(20)

      if request.format.symbol == :csv
        csv_data = CSV.generate do |csv|
          csv <<  ["\xEF\xBB\xBF用户ID","手机号", "交易时间	", "交易数量","交易状态", "交易类型"]
          @q.each do |ticket|
            csv << [ticket.user&.id,ticket.user&.mobile,ticket.create_time.strftime('%Y-%d-%m %H:%M'),ticket.fund,AccountTicketDetail::WEALTHTYPE[ticket.wealth_type],AccountTicketDetail::TRADTYPE.invert[ticket.trad_type]]
          end
        end
      end
      respond_to do |format|
        format.html
        format.csv { render text: csv_data }
      end
  end
end
