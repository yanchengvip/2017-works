class Retail::CartsController < ApplicationController
  before_action :set_retail_cart, only: [:show, :edit, :update, :destroy]

  # GET /retail/carts
  # GET /retail/carts.json
  def index
    @retail_carts = Retail::Cart.all
  end

  # GET /retail/carts/1
  # GET /retail/carts/1.json
  def show
  end

  # GET /retail/carts/new
  def new
    @retail_cart = Retail::Cart.new
  end

  # GET /retail/carts/1/edit
  def edit
  end

  # POST /retail/carts
  # POST /retail/carts.json
  def create
    @retail_cart = Retail::Cart.new(retail_cart_params)

    respond_to do |format|
      if @retail_cart.save
        format.html { redirect_to @retail_cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @retail_cart }
      else
        format.html { render :new }
        format.json { render json: @retail_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /retail/carts/1
  # PATCH/PUT /retail/carts/1.json
  def update
    respond_to do |format|
      if @retail_cart.update(retail_cart_params)
        format.html { redirect_to @retail_cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @retail_cart }
      else
        format.html { render :edit }
        format.json { render json: @retail_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retail/carts/1
  # DELETE /retail/carts/1.json
  def destroy
    @retail_cart.destroy
    respond_to do |format|
      format.html { redirect_to retail_carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retail_cart
      @retail_cart = Retail::Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retail_cart_params
      params.fetch(:retail_cart, {})
    end
end
