class ExchangeProductsController < ApplicationController
  before_action :set_exchange_product, only: [:show, :edit, :update, :destroy]

  # GET /exchange_products
  # GET /exchange_products.json
  def index
    @exchange_products = ExchangeProduct.all
  end

  # GET /exchange_products/1
  # GET /exchange_products/1.json
  def show
  end

  # GET /exchange_products/new
  def new
    @exchange_product = ExchangeProduct.new
  end

  # GET /exchange_products/1/edit
  def edit
  end

  # POST /exchange_products
  # POST /exchange_products.json
  def create
    @exchange_product = ExchangeProduct.new(exchange_product_params)

    respond_to do |format|
      if @exchange_product.save
        format.html { redirect_to @exchange_product, notice: 'Exchange product was successfully created.' }
        format.json { render :show, status: :created, location: @exchange_product }
      else
        format.html { render :new }
        format.json { render json: @exchange_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exchange_products/1
  # PATCH/PUT /exchange_products/1.json
  def update
    respond_to do |format|
      if @exchange_product.update(exchange_product_params)
        format.html { redirect_to @exchange_product, notice: 'Exchange product was successfully updated.' }
        format.json { render :show, status: :ok, location: @exchange_product }
      else
        format.html { render :edit }
        format.json { render json: @exchange_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exchange_products/1
  # DELETE /exchange_products/1.json
  def destroy
    @exchange_product.destroy
    respond_to do |format|
      format.html { redirect_to exchange_products_url, notice: 'Exchange product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange_product
      @exchange_product = ExchangeProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_product_params
      params.require(:exchange_product).permit(:symbol, :active, :published)
    end
end
