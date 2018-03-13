class Api::ChestBroadcastsController < Api::ApplicationController
  skip_before_action :authenticate_user
  def index
    @q = ChestBroadcast.active.where(published: true).ransack(params[:q])
    @chest_broadcasts = @q.result.page(params[:page]).per(15)
    render json: {"execResult"=>true, "execMsg"=>"", "execData"=>{chest_broadcasts: @chest_broadcasts.as_json({only: [:id, :content ]})}, "execDatas"=>[], "execErrCode"=>"200"}
  end
end
