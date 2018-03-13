class ChestBoxMsgsController < ApplicationController
  before_action :side_menus10
  skip_before_action :verify_authenticity_token

  def index
    @chest_box_msgs = ChestBoxMsg.all.order(msg_type: :asc).active
  end


  def msg_create
    #ChestBoxMsg.find(params[:name])

    5.times do |i|
      msg1 = ChestBoxMsg.where(msg_type: i+1).active.first
      m = ('m' + (i+1).to_s).to_sym
      if msg1
        msg1.update_attributes(content: params[m])
      else
        ChestBoxMsg.create(content: params[m],msg_type: i+1)
      end
    end
    flash[:success] = '修改成功！'
    redirect_to :back
  end
end