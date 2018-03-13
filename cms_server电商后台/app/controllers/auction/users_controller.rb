class Auction::UsersController < ApplicationController
  before_action :set_auction_user, only: [:show, :edit, :destroy]
  before_action :side_menus4

  def index
    @bread_menu = {m1: 'VIP管理', m2: 'VIP管理', m2_url: '/auction/users', m3: 'VIP列表', add: '/auction/users/new', s: 'users_search'}
    @q = Auction::User.ransack(params[:q])
    @auction_users = @q.result.includes(:level).page(params[:page]).per(15)
  end

  def show
    @bread_menu = {m1: 'VIP管理', m2: 'VIP管理', m2_url: '/auction/users', m3: 'VIP详情'}
  end

  def new
    @bread_menu = {m1: 'VIP管理', m2: 'VIP管理', m2_url: '/auction/users', m3: '新增VIP'}
    @auction_user = Auction::User.new
  end

  def edit
    @bread_menu = {m1: 'VIP管理', m2: 'VIP管理', m2_url: '/auction/users', m3: '修改VIP'}
  end

  def create
    begin
      if auction_user = Auction::User.find_by(id: auction_user_params[:id])
        auction_user.update_attributes!(level_id: auction_user_params[:level_id])
        flash_msg('success', '添加VIP成功！', 'index')
      else
        flash_msg('danger', "添加VIP失败！id 为#{auction_user_params[:id]}的用户不存在", 'new')
      end
    rescue Exception => e
      flash_msg('danger', "添加VIP失败！", 'new')
    end
  end

  def update
    @auction_user = Auction::User.find auction_user_params[:id]

    begin
      if @auction_user.update_attributes!(level_id: auction_user_params[:level_id])
        flash_msg('success', '修改VIP成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = '修改VIP失败！#{error_msg(@auction_user)}'
      return redict_to action: 'edit', id: @auction_user.id
    end
  end

  def destroy
    if @auction_user.update_attributes!(level_id: 1)
      return flash_msg('success', '已成功删除!', 'index')
    end
    flash_msg('danger', '删除失败！', 'index')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_user
      @auction_user = Auction::User.includes(:level).find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_user_params
      # params.fetch(:auction_user, {})
      params.require(:auction_user).permit(:id, :level_id)
    end

end
