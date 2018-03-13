class AccountMedalsController < ApplicationController
  before_action :set_account_medal, only: [:show, :edit, :update, :destroy]

  # GET /account_medals
  # GET /account_medals.json
  def index
    @account_medals = AccountMedal.all
  end

  # GET /account_medals/1
  # GET /account_medals/1.json
  def show
  end

  # GET /account_medals/new
  def new
    @account_medal = AccountMedal.new
  end

  # GET /account_medals/1/edit
  def edit
  end

  # POST /account_medals
  # POST /account_medals.json
  def create
    @account_medal = AccountMedal.new(account_medal_params)

    respond_to do |format|
      if @account_medal.save
        format.html { redirect_to @account_medal, notice: 'Account medal was successfully created.' }
        format.json { render :show, status: :created, location: @account_medal }
      else
        format.html { render :new }
        format.json { render json: @account_medal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_medals/1
  # PATCH/PUT /account_medals/1.json
  def update
    respond_to do |format|
      if @account_medal.update(account_medal_params)
        format.html { redirect_to @account_medal, notice: 'Account medal was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_medal }
      else
        format.html { render :edit }
        format.json { render json: @account_medal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_medals/1
  # DELETE /account_medals/1.json
  def destroy
    @account_medal.destroy
    respond_to do |format|
      format.html { redirect_to account_medals_url, notice: 'Account medal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_medal
      @account_medal = AccountMedal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_medal_params
      params.require(:account_medal).permit(:account_id, :medal_id, :medal_type)
    end
end
