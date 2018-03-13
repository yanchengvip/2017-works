class Auction::UnitsController < ApplicationController


  def return
    res = Auction::Unit.return params.merge(user_id: current_user['id'])
    render json: {status: res['comm']['code'], msg: res['comm']['msg'], data: res['data'] || []}
  end

  #退货信息
  def return_detail
    res = Auction::Unit.return_detail params
    render json: {status: res['comm']['code'], msg: res['comm']['msg'], data: res['data'] || []}
  end

end
