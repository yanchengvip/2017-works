class Supplier::TradesController < Supplier::ApplicationController
  before_action :set_supplier_trade, only: [:reject, :show, :edit, :update, :destroy, :print, :ship]

  # GET /supplier/trades
  # GET /supplier/trades.json
  def index
    params[:q] ||= {}
    params[:q][:s] ||= "updated_at desc"
    if !params[:name].blank?
      @trades = Supplier::Trade.own(current_user.id).includes(:units, :auction_trade, :auction_skus, :account)
      .joins('left join auction_trades as at on at.id = supplier_trades.auction_trade_id left join auction_contacts as ac on ac.id = at.contact_id').where('at.id = supplier_trades.auction_trade_id and ac.name = ?', params[:name])
      .ransack(params[:q]).result.page(params[:page] || 1)
    else
      @trades = Supplier::Trade.own(current_user.id).includes(:units, :auction_trade, :auction_skus, :account).ransack(params[:q]).result.page(params[:page] || 1)
    end
  end



  # GET /supplier/trades/1
  # GET /supplier/trades/1.json
  def show
  end



  # POST /supplier/trades
  # POST /supplier/trades.json
  def create
    @supplier_trade = Supplier::Trade.new(supplier_trade_params)

    respond_to do |format|
      if @supplier_trade.save
        format.html { redirect_to @supplier_trade, notice: 'Trade was successfully created.' }
        format.json { render :show, status: :created, location: @supplier_trade }
      else
        format.html { render :new }
        format.json { render json: @supplier_trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier/trades/1
  # PATCH/PUT /supplier/trades/1.json
  def update
    respond_to do |format|
      if @supplier_trade.update(supplier_trade_params)
        format.html { redirect_to @supplier_trade, notice: 'Trade was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier_trade }
      else
        format.html { render :edit }
        format.json { render json: @supplier_trade.errors, status: :unprocessable_entity }
      end
    end
  end

  def print
    render layout: nil
  end

  def ship
    if params[:supplier_trade] && !params[:supplier_trade][:delivery_service].blank? && !params[:supplier_trade][:delivery_identifier].blank?
      @trade.update(params.require(:supplier_trade).permit(:delivery_service, :delivery_identifier).merge(ship_at: Time.now, status: "receive")) if @trade.status == 'ship'
      flash[:success] = 'success'
      return redirect_to action: :index
    else
      flash[:danger] = "填写正确的发货信息"
      return redirect_to '/supplier/trades?q[status_eq]=ship'
    end

  end

  def reject
    if @trade.status == "receive"
      @trade.update(status: "reject")
      render json:{status: 200, msg: "success", data:{trade: @trade}}
    else
      render json:{status: 500, msg: "订单状态不可拒签", data:{trade: @trade}}
    end
  end

  def return
    @trade.update(status: "return")

    render json:{status: 200, msg: "success", data:{trade: @trade}}
  end

  # DELETE /supplier/trades/1
  # DELETE /supplier/trades/1.json
  def destroy
    @supplier_trade.destroy
    respond_to do |format|
      format.html { redirect_to supplier_trades_url, notice: 'Trade was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_trade
      @trade = Supplier::Trade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_trade_params
      params.require(:supplier_trade).permit(:auction_trade_id, :provider_id, :status, :price, :payment_price, :tax_price, :active, :delivery_service, :delivery_identifier, :ship_at, :remark, :delivery_phone, :balance_price, :finish_at)
    end
end
