class Core::AccountsController < ApplicationController
  before_action :set_core_account, only: [:show, :edit, :update, :destroy]

  # GET /core/accounts
  # GET /core/accounts.json
  def index
    @core_accounts = Core::Account.all
  end

  # GET /core/accounts/1
  # GET /core/accounts/1.json
  def show
  end

  # GET /core/accounts/new
  def new
    @core_account = Core::Account.new
  end

  # GET /core/accounts/1/edit
  def edit
  end

  # POST /core/accounts
  # POST /core/accounts.json
  def create
    @core_account = Core::Account.new(core_account_params)

    respond_to do |format|
      if @core_account.save
        format.html { redirect_to @core_account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @core_account }
      else
        format.html { render :new }
        format.json { render json: @core_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/accounts/1
  # PATCH/PUT /core/accounts/1.json
  def update
    respond_to do |format|
      if @core_account.update(core_account_params)
        format.html { redirect_to @core_account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @core_account }
      else
        format.html { render :edit }
        format.json { render json: @core_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/accounts/1
  # DELETE /core/accounts/1.json
  def destroy
    @core_account.destroy
    respond_to do |format|
      format.html { redirect_to core_accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_account
      @core_account = Core::Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_account_params
      params.fetch(:core_account, {})
    end
end
