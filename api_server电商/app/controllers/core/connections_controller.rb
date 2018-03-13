class Core::ConnectionsController < ApplicationController
  before_action :set_core_connection, only: [:show, :edit, :update, :destroy]



  # GET /core/connections/new
  def new
    @core_connection = Core::Connection.new
  end



  # POST /core/connections
  # POST /core/connections.json
  # @param [Hash]
  # @param [string] :openid  openid
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    render json: {status: 200, msg: "绑定成功", data:{ "core_account": {
            "phone": "18810610046"
        },
        "user": {
            "name": "ww",
            "id": 1
        },
        "connection": {
            "account_id": 1
        }}} and return
    connection = Core::Connection.where(union_id: params[:openid], site: "wechat").first
    if connection
      #绑定过账户
      if core_account = Core::Account.where(id: connection[:account_id]).first
        user = Core::User.where(id: core_account[:id]).first
        render json: {status: 200, msg: "已绑定过了", data:{core_account: core_account.as_json, user: user.as_json, connection: connection.as_json}}
      else
        core_account = Core::Account.create(ip_address: request.remote_ip, link_id: cookies[:link_id], click_id: cookies[:click_id])
        user = Core::User.create(name: connection[:name], id: account[:id])
        if core_account && user
          connection = Core::Connection.update(account_id: account[:id])
          render json: {status: 200, msg: "绑定成功", data:{core_account: core_account.as_json, user: user.as_json, connection: connection.as_json}}
        else
          render json: {status: 500, msg: "失败", data:{}}
        end
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_connection
      @core_connection = Core::Connection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_connection_params
      params.fetch(:core_connection, {})
    end
end
