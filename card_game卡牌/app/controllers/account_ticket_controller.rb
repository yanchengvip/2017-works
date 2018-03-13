require 'csv'
class AccountTicketController < ApplicationController
  before_action :side_menus10

  def index
     @q = AccountTicket.includes(:user).active.ransack(params[:q]).result
     @account_tickets = @q.page(params[:page]).per(20)
     if request.format.symbol == :csv
       csv_data = CSV.generate do |csv|
         csv <<  ["\xEF\xBB\xBF用户ID","手机号", "开启机会次数余额	", "宝箱符余额"]
         @q.where("treasure_total_amount > 0").each do |ticket|
           csv << [ticket.user&.id,ticket.user&.mobile,ticket.free_treasure_amount,ticket.treasure_total_amount]
         end
       end
     end
     respond_to do |format|
       format.html
       format.csv { render text: csv_data }
     end
  end
end
