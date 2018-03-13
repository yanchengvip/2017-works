class AccountTicketBalanceDetailsController < ApplicationController
  before_action :set_account_ticket_balance_detail, only: [:show, :edit, :update, :destroy]

  # GET /account_ticket_balance_details
  # GET /account_ticket_balance_details.json
  def index
    @account_ticket_balance_details = AccountTicketBalanceDetail.all
  end

  # GET /account_ticket_balance_details/1
  # GET /account_ticket_balance_details/1.json
  def show
  end

  # GET /account_ticket_balance_details/new
  def new
    @account_ticket_balance_detail = AccountTicketBalanceDetail.new
  end

  # GET /account_ticket_balance_details/1/edit
  def edit
  end

  # POST /account_ticket_balance_details
  # POST /account_ticket_balance_details.json
  def create
    @account_ticket_balance_detail = AccountTicketBalanceDetail.new(account_ticket_balance_detail_params)

    respond_to do |format|
      if @account_ticket_balance_detail.save
        format.html { redirect_to @account_ticket_balance_detail, notice: 'Account ticket balance detail was successfully created.' }
        format.json { render :show, status: :created, location: @account_ticket_balance_detail }
      else
        format.html { render :new }
        format.json { render json: @account_ticket_balance_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_ticket_balance_details/1
  # PATCH/PUT /account_ticket_balance_details/1.json
  def update
    respond_to do |format|
      if @account_ticket_balance_detail.update(account_ticket_balance_detail_params)
        format.html { redirect_to @account_ticket_balance_detail, notice: 'Account ticket balance detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_ticket_balance_detail }
      else
        format.html { render :edit }
        format.json { render json: @account_ticket_balance_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_ticket_balance_details/1
  # DELETE /account_ticket_balance_details/1.json
  def destroy
    @account_ticket_balance_detail.destroy
    respond_to do |format|
      format.html { redirect_to account_ticket_balance_details_url, notice: 'Account ticket balance detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_ticket_balance_detail
      @account_ticket_balance_detail = AccountTicketBalanceDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_ticket_balance_detail_params
      params.require(:account_ticket_balance_detail).permit(:account_ticket_id, :user_id, :fund, :trad_type)
    end
end
