class Supplier::ProvidersController < Supplier::ApplicationController
  before_action :set_supplier_provider, only: [:show, :edit, :update, :destroy]

  # GET /supplier/providers
  # GET /supplier/providers.json
  def index
    @supplier_providers = Supplier::Provider.all
  end

  # GET /supplier/providers/1
  # GET /supplier/providers/1.json
  def show
  end

  # GET /supplier/providers/new
  def new
    @supplier_provider = Supplier::Provider.new
  end

  # GET /supplier/providers/1/edit
  def edit
  end

  # POST /supplier/providers
  # POST /supplier/providers.json
  def create
    @supplier_provider = Supplier::Provider.new(supplier_provider_params)

    respond_to do |format|
      if @supplier_provider.save
        format.html { redirect_to @supplier_provider, notice: 'Provider was successfully created.' }
        format.json { render :show, status: :created, location: @supplier_provider }
      else
        format.html { render :new }
        format.json { render json: @supplier_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier/providers/1
  # PATCH/PUT /supplier/providers/1.json
  def update
    respond_to do |format|
      if @supplier_provider.update(supplier_provider_params)
        format.html { redirect_to @supplier_provider, notice: 'Provider was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier_provider }
      else
        format.html { render :edit }
        format.json { render json: @supplier_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_password
    @supplier_provider = current_user
  end

  def update_password
    if Supplier::Provider.auth(current_user.login, params[:supplier_provider][:password]) && params[:supplier_provider][:new_password] == params[:supplier_provider][:password_confirm] && !params[:supplier_provider][:new_password].blank?
      current_user.update(password: params[:supplier_provider][:new_password])
      redirect_to "/supplier", flash: {success: "密码修改成功"}
    else
      @supplier_provider = current_user
      flash.now[:danger]= "密码错误或两次新密码不一致"
      render :reset_password
    end
  end

  # DELETE /supplier/providers/1
  # DELETE /supplier/providers/1.json
  def destroy
    @supplier_provider.destroy
    respond_to do |format|
      format.html { redirect_to supplier_providers_url, notice: 'Provider was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_provider
      @supplier_provider = Supplier::Provider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_provider_params
      params.require(:supplier_provider).permit(:name, :description, :active, :login, :password, :salt)
    end
end
