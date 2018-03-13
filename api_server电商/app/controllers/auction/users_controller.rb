class Auction::UsersController < ApplicationController


  # GET /auction/users/1
  def show
    params = {
      id: current_user[:id]
    }
    auction_users = Auction::User.users params
    if auction_users[:comm][:code] == "200"
      render json: {status: auction_users[:comm][:code].to_i, msg: auction_users[:comm][:msg], data: {auction_users: auction_users[:data][:auction_users]}}
    else
      render json: {status: auction_users[:comm][:code].to_i, msg: auction_users[:comm][:msg], data: {}}
    end
  end


  #更新用户基本信息修改手机号、密码、 邮箱、
  # PATCH/PUT /auction/users/1
  # @param [Hash] core_user 更新
  # @param [string] user[name]  姓名
  # @param [string] user[sex]   性别
  # @param [datetime] user[birthday]  生日
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def update
    params[:user].merge!(id: current_user[:id])
    auction_users = Auction::User.updateuser params
    render json: {status: auction_users[:comm][:code].to_i, msg: auction_users[:comm][:msg], data: {}}
  end


  private

    def set_auction_user
      @auction_user = Auction::User.find(params[:id])
    end


    def auction_user_params
      params.fetch(:auction_user, {})
    end
end
