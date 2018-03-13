class Manage::ProvidersController < ApplicationController
  before_action :set_manage_provider, only: [:show, :edit, :update, :destroy]
  before_action :side_menus5

  # GET /manage/providers
  # GET /manage/providers.json
  def index
    @bread_menu = {m1: '供应商管理', m2: '供应商管理', m2_url: '/manage/providers', m3: '供应商列表',add: '/manage/providers/new', s: 'providers_search'}
    @q = Manage::Provider.ransack(params[:q])
    @manage_providers = @q.result.page(params[:page]).per(15)
  end

  # GET /manage/providers/1
  # GET /manage/providers/1.json
  def show
  end

  # GET /manage/providers/new
  def new
    @bread_menu = {m1: '供应商管理', m2: '供应商管理', m2_url: '/manage/providers/new', m3: '新增供应商'}
    @manage_provider = Manage::Provider.new
    @manage_provider_type = Manage::Provider::TYPE.invert.to_a
    @manage_provider_invoice_type = Manage::Provider::INVOICETYPE.invert.to_a
    @manage_provider_is_direct_ship = Manage::Provider::ISDIRECTSHIP.invert.to_a
    @manage_provider_is_cod = Manage::Provider::ISCOD.invert.to_a
  end

  # GET /manage/providers/1/edit
  def edit
    @bread_menu = {m1: '供应商管理', m2: '供应商管理', m2_url: '/manage/providers/edit', m3: '修改供应商'}
    @manage_provider_type = Manage::Provider::TYPE.invert.to_a
    @manage_provider_invoice_type = Manage::Provider::INVOICETYPE.invert.to_a
    @manage_provider_is_direct_ship = Manage::Provider::ISDIRECTSHIP.invert.to_a
    @manage_provider_is_cod = Manage::Provider::ISCOD.invert.to_a
  end

  # POST /manage/providers
  # POST /manage/providers.json
  def create
    provider = Manage::Provider.find_by(login: manage_provider_params[:login])
    if provider
      flash_msg('danger', "此账号已经存在", 'new')
    else
      manage_provider = Manage::Provider.new(manage_provider_params)
      begin
        if manage_provider.save
          flash_msg('success', '添加供应商成功！', 'index')
        end
      rescue Exception => e
        flash_msg('danger', "添加供应商失败！#{error_msg(manage_provider)}", 'new')
      end
    end
  end

  # PATCH/PUT /manage/providers/1
  # PATCH/PUT /manage/providers/1.json
  def update
    if @manage_provider.update(manage_provider_params)
      flash[:success] = '添加成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/manage/providers'
  end

  # DELETE /manage/providers/1
  # DELETE /manage/providers/1.json
  def destroy
    @manage_provider.destroy
    respond_to do |format|
      format.html { redirect_to auction_providers_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    def set_manage_provider
      @manage_provider = Manage::Provider.find(params[:id]) if params[:id]
    end

    def manage_provider_params
      # params.fetch(:auction_provider, {})
      params.require(:manage_provider).permit!
    end

end
