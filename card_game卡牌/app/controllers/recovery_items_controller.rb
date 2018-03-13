class RecoveryItemsController < ApplicationController
  before_action :set_recovery_item, only: [:show, :edit, :update, :destroy]
  before_action :side_menus11
  # GET /recovery_items
  # GET /recovery_items.json
  def index

    @q = RecoveryItem.active.ransack(params[:q])
    @recovery_items = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户名称 用户手机 回收数量 对应金额 回收状态)
        @q.result.each do |recovery_item|
          csv << [recovery_item.user&.nick_name,recovery_item.user&.mobile,recovery_item.count,recovery_item.recovery.total_cost,recovery_item.recovery.status]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  # GET /recovery_items/1
  # GET /recovery_items/1.json
  def show
  end
  def display
    if params[:recovery_id]
      @recovery_items = RecoveryItem.where(:recovery_id => params[:recovery_id]).page(params[:page]).per(15)
    else
      @recovery_items = RecoveryItem.active.ransack(params[:q]).result.page(params[:page]).per(15)
    end
    render :display
  end

  # GET /recovery_items/new
  def new
    @recovery_item = RecoveryItem.new
  end

  # GET /recovery_items/1/edit
  def edit
  end

  # POST /recovery_items
  # POST /recovery_items.json
  def create
    @recovery_item = RecoveryItem.new(recovery_item_params)

    respond_to do |format|
      if @recovery_item.save
        format.html { redirect_to @recovery_item, notice: 'Recovery item was successfully created.' }
        format.json { render :show, status: :created, location: @recovery_item }
      else
        format.html { render :new }
        format.json { render json: @recovery_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recovery_items/1
  # PATCH/PUT /recovery_items/1.json
  def update
    respond_to do |format|
      if @recovery_item.update(recovery_item_params)
        format.html { redirect_to @recovery_item, notice: 'Recovery item was successfully updated.' }
        format.json { render :show, status: :ok, location: @recovery_item }
      else
        format.html { render :edit }
        format.json { render json: @recovery_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recovery_items/1
  # DELETE /recovery_items/1.json
  def destroy
    @recovery_item.destroy
    respond_to do |format|
      format.html { redirect_to recovery_items_url, notice: 'Recovery item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recovery_item
      @recovery_item = RecoveryItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recovery_item_params
      params.require(:recovery_item).permit(:chest_prize_id, :user_id, :recovery_id, :delete_flag, :count)
    end
end
