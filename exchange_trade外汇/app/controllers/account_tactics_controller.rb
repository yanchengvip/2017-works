class AccountTacticsController < ApplicationController
  before_action :set_account_tactic, only: [:show, :edit, :update, :destroy]

  # GET /account_tactics
  # GET /account_tactics.json
  def index
    @account_tactics = AccountTactic.all
  end

  # GET /account_tactics/1
  # GET /account_tactics/1.json
  def show
  end

  # GET /account_tactics/new
  def new
    @account_tactic = AccountTactic.new
  end

  # GET /account_tactics/1/edit
  def edit
  end

  # POST /account_tactics
  # POST /account_tactics.json
  def create
    @account_tactic = AccountTactic.new(account_tactic_params)

    respond_to do |format|
      if @account_tactic.save
        format.html { redirect_to @account_tactic, notice: 'Account tactic was successfully created.' }
        format.json { render :show, status: :created, location: @account_tactic }
      else
        format.html { render :new }
        format.json { render json: @account_tactic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_tactics/1
  # PATCH/PUT /account_tactics/1.json
  def update
    respond_to do |format|
      if @account_tactic.update(account_tactic_params)
        format.html { redirect_to @account_tactic, notice: 'Account tactic was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_tactic }
      else
        format.html { render :edit }
        format.json { render json: @account_tactic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_tactics/1
  # DELETE /account_tactics/1.json
  def destroy
    @account_tactic.destroy
    respond_to do |format|
      format.html { redirect_to account_tactics_url, notice: 'Account tactic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_tactic
      @account_tactic = AccountTactic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_tactic_params
      params.require(:account_tactic).permit(:account_id, :tactic_id, :follow_money, :dealer_type, :dealer_id, :active)
    end
end
