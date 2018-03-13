class Api::ChestRecordItemsController < Api::ApplicationController
  def index
    # q = @current_user.chest_record_items.includes(:chest_prize, :chest_box).order(id: :desc).ransack(params[:q])
    q =ChestRecordItem.joins("join chest_records on chest_records.id = chest_record_id").where("chest_records.user_id = ?", @current_user.id).order(id: :desc).ransack(params[:q])
    chest_record_items = q.result.page(params[:page]).per(15)
    render json: {execResult: true, execMsg: '成功', execErrCode: 200, execDatas: {chest_record_items: chest_record_items.as_json(ChestRecordItem.xml_options)}}
  end

  def total
    record_total_count = Rails.cache.fetch("record_total_count:#{current_user.id}", expires_in: 10) {
      {
          0 => ChestRecord.where(user_id: current_user["id"]).where.not(chest_prize_ids: '').count,
          1 => ChestRecord.where("(status in (0, 1, 3) ) or (status = 2 and ship_status = 2)").where(user_id: current_user["id"]).where.not(chest_prize_ids: '').count,
          2 => ChestRecord.where("status = 2 and (phonecard_prizes_status = 1 or ship_status in (3,4))").where(user_id: current_user["id"]).count,
          3 => ChestRecord.where("status = 4 or phonecard_prizes_status = 3  or (phonecard_prizes_status = 0 and ship_status = 0 and status = 2)").where(user_id: current_user["id"]).count
      }
    }
    render json: {execResult: true, execMsg: '成功', execErrCode: 200, execDatas: {
        total: {
            "2": $redis.get("chest_record_item_total:2:#{current_user.id}").to_i,
            "3": $redis.get("chest_record_item_total:3:#{current_user.id}").to_i,
            "6": $redis.get("chest_record_item_total:6:#{current_user.id}").to_i
        },
        record_total_count: record_total_count
      }
    }
  end
end
