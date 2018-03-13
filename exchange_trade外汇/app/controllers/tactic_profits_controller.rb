class TacticProfitsController < ApplicationController
  before_action :set_tactic_profit, only: [:show, :edit, :update, :destroy]

  # GET /tactic_profits
  # GET /tactic_profits.json
  def index
    @tactic_profits = TacticProfit.all
  end

  # GET /tactic_profits/1
  # GET /tactic_profits/1.json
  def show
  end

  # GET /tactic_profits/new
  def new
    @tactic_profit = TacticProfit.new
  end

  # GET /tactic_profits/1/edit
  def edit
  end

  # POST /tactic_profits
  # POST /tactic_profits.json
  def create
    @tactic_profit = TacticProfit.new(tactic_profit_params)

    respond_to do |format|
      if @tactic_profit.save
        format.html { redirect_to @tactic_profit, notice: 'Tactic profit was successfully created.' }
        format.json { render :show, status: :created, location: @tactic_profit }
      else
        format.html { render :new }
        format.json { render json: @tactic_profit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tactic_profits/1
  # PATCH/PUT /tactic_profits/1.json
  def update
    respond_to do |format|
      if @tactic_profit.update(tactic_profit_params)
        format.html { redirect_to @tactic_profit, notice: 'Tactic profit was successfully updated.' }
        format.json { render :show, status: :ok, location: @tactic_profit }
      else
        format.html { render :edit }
        format.json { render json: @tactic_profit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tactic_profits/1
  # DELETE /tactic_profits/1.json
  def destroy
    @tactic_profit.destroy
    respond_to do |format|
      format.html { redirect_to tactic_profits_url, notice: 'Tactic profit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tactic_profit
      @tactic_profit = TacticProfit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tactic_profit_params
      params.require(:tactic_profit).permit(:account_id, :tactic_id, :amount, :date, :dealer_type)
    end
end
