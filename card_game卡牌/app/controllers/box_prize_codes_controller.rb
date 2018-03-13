class BoxPrizeCodesController < ApplicationController
  before_action :side_menus10
  skip_before_action :verify_authenticity_token


  def index
    @box_prizes = BoxPrize.includes(:box_prize_codes).active.page(params[:page]).per(30)
  end

  def show
    @box_prize = BoxPrize.find(params[:id])
    @box_prize_codes = BoxPrizeCode.where(box_prize_id: params[:id]).active.page(params[:page]).per(30)
    if @box_prize.prize_type == 1
      @all_num = BoxPrizeCode.where(box_prize_id: params[:id]).active.count
      @not_use_num = BoxPrizeCode.where(box_prize_id: params[:id], use_num: 0).count
      @use_num = @all_num - @not_use_num
    elsif @box_prize.prize_type == 2
      @all_num = @box_prize_codes.first&.num
      @not_use_num = @box_prize_codes.first&.num - @box_prize_codes.first&.use_num
      @use_num = @box_prize_codes.first&.use_num

    end
  end

  #创建兑奖码
  def create_box_prize
    bp = BoxPrize.create(box_prize_params.merge(valid_date: Time.now + (params[:valid_date].to_i).days))
    bp.generate_codes params[:num]
    redirect_to '/box_prize_codes'
  end

  #追加兑奖码
   def add_box_prize_codes
     bp = BoxPrize.find(params[:box_prize_id])
     bp.add_codes params[:num]
     redirect_to '/box_prize_codes'
   end

  #删除兑奖码
  def destroy_prize
    bp = BoxPrize.find(params[:id])
    bp.destroy
    redirect_to '/box_prize_codes'
  end

  #禁用/启用
  def box_prize_status
    bp = BoxPrize.find(params[:id])
    bp.update_attributes(status: params[:status])
    redirect_to '/box_prize_codes'
  end


  #下载code csv
  def down_csv
    respond_to do |format|
      format.csv { send_data BoxPrizeCode.to_csv_for_codes(params[:box_prize_id]), filename:"prize_codes.csv"}
    end
  end

  private

  def box_prize_params
    params.permit(:name, :treasure_amount,:free_treasure_amount,:treasure_type, :valid_date, :limit_num, :remark, :prize_type, :status)
  end

end
