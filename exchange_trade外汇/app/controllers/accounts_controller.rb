class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy]

  # 关注大师。
  #
  # GET /accounts/id/follow
  #
  # @param [integer] :id  大师id
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def follow
    account = Account.acquire(params[:id])
    @current_account.create_action(:follow, target: account)
    render json: {status: 200, msg: "关注大师成功", data: {}}
  end

  # 取消关注大师。
  #
  # GET /accounts/id/destroy_follow
  #
  # @param [integer] :id  大师id
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def destroy_follow
    account = Account.acquire(params[:id])
    @current_account.destroy_action(:follow, target: account)
    render json: {status: 200, msg: "取消关注大师成功", data: {}}
  end

  # 关注大师列表。
  #
  # GET /accounts/follow_list
  #
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{follow_lists: Array<Action>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def follow_list
    follow_lists = @current_account.follow_user_actions
    render json: {status: 200, msg: "获取关注大师列表成功", data: {follow_lists: follow_lists.as_json}}
  end



  # 大师列表。
  #
  # GET /accounts
  #
  # @param [bool] q[is_master_true]  是否为牛人，true为牛人。false为跟随者
  # @param [string] q[name_cont]  搜索页面输入的牛人名字
  # @param [double] q[s] 收益率(yield_rate desc/asc),收益/盈亏(profit desc/asc),跟随收益(total_follow_trade_price desc/asc)
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{accounts: Array<Account>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    accounts = Account.active.ransack(params[:q]).result.includes(:user).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "success", data: {accounts: accounts.as_json(Account.xml_options) }}
  end


  #  账号详细信息
  #
  # GET /accounts/1
  # @param id [integer] 账号id
  #
  # @return ({data:{accounts: Array<Account>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def show
    account = Account.acquire(params[:id])
    render json: {status: 200, msg: "获取账号详细信息成功", data: {account: account.as_json}}
  end

  #  大师详情
  #
  # GET /accounts/1/master_detail
  # @param id [integer] 大师id
  #
  # @return ({data:{account: Array<Account>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def master_detail
    account = Account.acquire(params[:id])
    render json: {status: 200, msg: "获取大师详情成功", data: {account: account.as_json}}
  end


  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  #  模拟账号/真实账号
  #
  # GET /accounts/simulation_account
  # @param dealer_type [integer] 券商类型;0:无,1:模拟盘账户,2:wisdom账户
  #
  # @return ({data:{account: Array<Account>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def simulation_account
    account = currnet_user.accounts.where(dealer_type: params[:dealer_type])
    render json: {status: 200, msg: "success", data: {account: account.as_json}}
  end


  # 开户模拟账号接口
  # POST /accounts
  #
  # @return ({status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    dealer_id = Dealer.find_by(:dealer_type => 1).first&.id
    account = Account.new(:dealer_id => dealer_id, :dealer_type => 1, :name => @currnet_user.nickname, :phone => @currnet_user.phone, :email => @currnet_user.email, :img_url => @currnet_user.headimgurl)
    if account.save
      render json: {status: 200, msg: "开户成功", data: {account: account.as_json}}
    else
      render json: {status: 500, msg: "开户失败", data: {}}
    end
  end

  # 开户wisdom真实盘账号接口
  # POST /accounts/wisdom_external_account
  # @note 返回的url 需要post打开让用户填写注册表单
  # @return (({data:{ url: ""}, status: 200, msg:"success"}))
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def wisdom_external_account
    if currnet_user.accounts.where(dealer_type: 2).blank?
      render json: Api::Wisdom.external_account(current_user.id)
    else
      render json: {status: 500, msg: "已开户", data:{}}
    end
  end

  #  账号功勋详情
  #
  # GET /accounts/account_medals
  #
  # @return ({data:{account_medals: Array<AccountMedal>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def account_medals
    account_medals = @current_account.account_medals
    render json: {status: 200, msg: "获取账号功勋成功", data: {account_medals: account_medals.as_json}}
  end


  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:user_id, :dealer_id, :dealer_type, :status, :agent_account, :mt4_account, :mt4_group, :name, :email, :phone, :certificate, :certificate_num, :img_url)
    end
end
