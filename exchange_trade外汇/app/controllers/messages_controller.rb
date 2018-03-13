class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # 消息列表。
  #
  # GET /messages
  #
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{messages: Array<Message>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    messages = Message.active.includes(:from_user).where("user_ids = ? or user_ids = 'all'", @current_user.id).paginate(:page => params[:page])
    render json: {status: 200, msg: "获取消息列表。成功", data: {messages: messages.as_json(Message.xml_options) }}
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:msg_type, :body, :user_ids, :active, :from_user_id)
    end
end
