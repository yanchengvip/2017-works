class Mammon::UserWinningsController < ApplicationController
  before_action :set_mammon_user_winning, only: [:show]
  before_action :side_menus12

  #中奖记录
  def index
    @period = Mammon::Period.where(id: params[:period_id]).first
    @user_winnings = Mammon::UserWinning.includes(:user)
                         .where(period_id: params[:period_id]).page(params[:page]).per(30)
  end

  def show
  end

  #期次列表
  def period_list
    @periods = Mammon::Period.active.order(num: :asc).page(params[:page]).per(20)
  end


  #统计下载
  def download_csv
    @user_winnings = Mammon::UserWinning.includes(:user, :mammon_period, :mammon_period_item)
                         .where(prize_num: params[:prize_num]).order(created_at: :desc)
    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户昵称 用户手机 中奖期次 中奖号码 中奖金额 中奖等级 中奖时间)
        @user_winnings.each do |w|
          csv << [w.user&.nick_name, w.user&.mobile, w.mammon_period&.num, w.code, w.amount.to_f,
                  Mammon::PeriodItem::PrizeNum[w.prize_num.to_i], w.created_at.present? ? w.created_at.strftime('%Y-%d-%m %H:%M') : '']
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  private

  def set_mammon_user_winning
    @mammon_user_winning = Mammon::UserWinning.find(params[:id])
  end


  def mammon_user_winning_params
    params.require(:mammon_user_winning).permit(:mammon_period_item_id, :user_id, :period_id, :code, :amount, :prize_num, :status)
  end
end
