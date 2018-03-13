class RecoveriesController < ApplicationController
  before_action :set_recovery, only: [:show, :edit, :update, :destroy, :shut_down, :open, :modify_sort_index]
  before_action :side_menus11

  # GET /recoveries
  # GET /recoveries.json
  def index
    @recoveries = Recovery.where(:is_rule => true).active.page(params[:page]).per(15)
  end

  # GET /recoveries/1
  # GET /recoveries/1.json
  def show
    @recoveries = Recovery.includes(:recoveries).where(:recovery_id => params[:id])
  end

  #编辑排序
  def modify_sort_index
    if @recovery.update(:sort_index => params[:rank])
      flash[:success] = '成功'
      redirect_to '/recoveries'
    else
      flash[:danger] = '失败'
      redirect_to '/recoveries'
    end
  end

  # GET /recoveries/new
  def new
    @recovery = Recovery.new
  end

  # GET /recoveries/1/edit
  def edit
  end

  # POST /recoveries
  # POST /recoveries.json
  def create
    @recovery = Recovery.new(recovery_params.merge(admin_id: current_user.id, is_rule: params[:is_rule]))
    if @recovery.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加失败！'
      return render action: :new
    end
  end

  # PATCH/PUT /recoveries/1
  # PATCH/PUT /recoveries/1.json
  def update
    respond_to do |format|
      if @recovery.update(recovery_params.merge(admin_id: current_user.id, is_rule: params[:is_rule]))
        format.html { redirect_to @recovery, notice: '修改成功' }
        format.json { render :index, status: :ok, location: @recovery }
      else
        format.html { render :edit }
        format.json { render json: @recovery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recoveries/1
  # DELETE /recoveries/1.json
  def destroy
    @recovery.destroy
    respond_to do |format|
      format.html { redirect_to recoveries_url, notice: 'Recovery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  #开启
  def open
    if @recovery.update(:status => 0)
      flash[:success] = '成功'
      redirect_to '/recoveries'
    else
      flash[:danger] = '失败'
      redirect_to '/recoveries'
    end
  end
  #关闭
  def shut_down
    if @recovery.update(:status => 1)
      flash[:success] = '成功'
      redirect_to '/recoveries'
    else
      flash[:danger] = '失败'
      redirect_to '/recoveries'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recovery
      @recovery = Recovery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recovery_params
      params.require(:recovery).permit!
    end
end
