class Auction::TransactionsController < ApplicationController
  before_action :set_auction_transaction, only: [:show, :edit, :update, :destroy]

  # GET /auction/transactions
  # GET /auction/transactions.json
  def index
    @auction_transactions = Auction::Transaction.all
  end

  # GET /auction/transactions/1
  # GET /auction/transactions/1.json
  def show
  end

  # GET /auction/transactions/new
  def new
    @auction_transaction = Auction::Transaction.new
  end

  # GET /auction/transactions/1/edit
  def edit
  end

  # POST /auction/transactions
  # POST /auction/transactions.json
  def create
    @auction_transaction = Auction::Transaction.new(auction_transaction_params)

    respond_to do |format|
      if @auction_transaction.save
        format.html { redirect_to @auction_transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @auction_transaction }
      else
        format.html { render :new }
        format.json { render json: @auction_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/transactions/1
  # PATCH/PUT /auction/transactions/1.json
  def update
    respond_to do |format|
      if @auction_transaction.update(auction_transaction_params)
        format.html { redirect_to @auction_transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_transaction }
      else
        format.html { render :edit }
        format.json { render json: @auction_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/transactions/1
  # DELETE /auction/transactions/1.json
  def destroy
    @auction_transaction.destroy
    respond_to do |format|
      format.html { redirect_to auction_transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_transaction
      @auction_transaction = Auction::Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_transaction_params
      params.fetch(:auction_transaction, {})
    end
end
