require 'csv'
class ChestRecordsController < ApplicationController
  before_action :side_menus10
  before_action :set_chest_record

  def index
    relation = ChestRecord.includes(:user).active
    relation = relation.joins("left join user on user.id = chest_records.user_id").where("user.mobile = ?", params[:mobile]) unless params[:mobile].blank?

    relation = relation.joins("left join user on user.id = chest_records.user_id").where("user.opsrc = ?", params[:opsrc]) unless params[:opsrc].blank?

    relation = relation.joins("left join chest_boxs on chest_boxs.id = chest_records.chest_box_id").where("chest_boxs.chest_type = ?", params[:chest_type]) unless params[:chest_type].blank?
    # @relation = relation.where("chest_box.chest_type = ?", params[:chest_type]) if params[:chest_type]

    if params[:q][:prize_type_eq] == 'phonecard'
      params[:q].delete(:prize_type_eq)
      params[:q].merge!(phonecard_prizes_status_not_eq: 0)
    end
    @q = relation.ransack(params[:q])
    @chest_records = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 用户渠道编号 手机号 开启时间 宝箱类型 奖品明细 收货人姓名 收货人电话 收货地址 )
        @q.result.each do |chest_record|
          csv << [chest_record.user&.id, chest_record.user&.opsrc,chest_record.user&.login_name, chest_record.created_at&.strftime("%Y-%m-%d %H:%M"), ChestBox::CHEST_TYPE[chest_record.chest_box&.chest_type], ChestPrize.where(id: chest_record.chest_prize_ids.split(",")).map{|x| x.name}, chest_record.address&.consignee,  chest_record.address&.mobile, chest_record.address&.detailed_address]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  def get_ship_info
    @address_info = JSON.parse(@chest_record.address_info)
    # return render json: {status: 200, msg: 'success', data: address_info.merge(ship_server: @chest_record.ship_server, ship_code: @chest_record.ship_code).as_json}
    return render partial: 'ship_content'
  end

  def ship
    if (@chest_record.ship_status == 3 || @chest_record.ship_status == 4) && @chest_record.update_attributes!(ship_status: 1)
      return render json: {status: 200, msg: 'success', data: ''}
    end
    return render json: {status: 500, msg: '状态错误', data: ''}
  end

  def grant_voucher
    if @chest_record.voucher_prizes_status == 1 && @chest_record.update_attributes!(voucher_prizes_status: 3)
      return render json: {status: 200, msg: 'success', data: ''}
    end
    return render json: {status: 500, msg: '发券状态错误', data: ''}
  end

  private
  def set_chest_record
    @chest_record = ChestRecord.find params[:id] if params[:id]
  end

end
