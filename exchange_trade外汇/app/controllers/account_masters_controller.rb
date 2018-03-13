class AccountMastersController < ApplicationController
  before_action :set_account_master, only: [:show, :edit, :update, :destroy]


  # 跟随者列表。
  #
  # GET /account_masters
  #
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{account_masters: Array<AccountMaster>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    account_masters = AccountMaster.active.includes(:account).order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "获取跟随者列表成功", data: {account_masters: account_masters.as_json(AccountMaster.xml_options) }}
  end

  # 取消跟随。
  #
  # GET /account_masters/id/un_follow
  #
  # @param id [integer] 大师id
  #
  # @return ({data:{, status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def un_follow
    account_master = AccountMaster.find_by(:account_id => @current_account.id, :master_id => params[:id])
    if account_master.destroy
      render json: {status: 200, msg: "取消跟随成功", data: {}}
    else
      render json: {status: 500, msg: "取消跟随失败", data: {}}
    end
  end

  # GET /account_masters/1
  # GET /account_masters/1.json
  def show
  end

  # GET /account_masters/new
  def new
    @account_master = AccountMaster.new
  end

  # GET /account_masters/1/edit
  def edit
  end



  # 跟牛人。跟随接口
  # POST /account_masters
  # @param [Hash] account_masters 跟随
  # @param [string] account_master[master_id]  跟随的牛人的id
  # @param [integer]  account_master[dealer_id] 券商表dealers表ID
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    dealer = Dealer.find(account_master_params[:dealer_id])
    if @current_account.margin_free.to_f < 100
      render json: {status: 500, msg: "保证金不足", data: {}}
    else
      account_master = AccountMaster.new(account_master_params.merge(request_ip: request.remote_ip, account_id: @current_account.id, dealer_type: dealer.dealer_type))
      if account_master.save
        render json: {status: 200, msg: "跟随成功", data: {}}
      else
        render json: {status: 500, msg: "跟随失败", data: {}}
      end
    end
  end

  # PATCH/PUT /account_masters/1
  # PATCH/PUT /account_masters/1.json
  def update
    respond_to do |format|
      if @account_master.update(account_master_params)
        format.html { redirect_to @account_master, notice: 'Account master was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_master }
      else
        format.html { render :edit }
        format.json { render json: @account_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_masters/1
  # DELETE /account_masters/1.json
  def destroy
    @account_master.destroy
    respond_to do |format|
      format.html { redirect_to account_masters_url, notice: 'Account master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_master
      @account_master = AccountMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_master_params
      params.require(:account_master).permit!
    end
end
