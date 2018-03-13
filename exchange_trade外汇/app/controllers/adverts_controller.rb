class AdvertsController < ApplicationController
  before_action :set_advert, only: [:show, :edit, :update, :destroy]


  # 轮播图列表。
  #
  # GET /adverts
  #
  # @param page [integer] 分页数, default: 1
  #
  # @return ({data:{adverts: Array<Advert>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    adverts = Advert.active.order(created_at: :desc).paginate(:page => params[:page] || 1)
    render json: {status: 200, msg: "成功", data: {adverts: adverts.as_json }}
  end


  # 轮播图详情。
  #
  # GET /adverts/1
  # @param id [integer] 轮播图id
  #
  # @return ({data:{advert: Array<Advert>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def show
    render json: {status: 200, msg: "成功", data: {advert: @advert.as_json }}
  end

  # GET /adverts/new
  def new
    @advert = Advert.new
  end

  # GET /adverts/1/edit
  def edit
  end

  # POST /adverts
  # POST /adverts.json
  def create
    @advert = Advert.new(advert_params)

    respond_to do |format|
      if @advert.save
        format.html { redirect_to @advert, notice: 'Advert was successfully created.' }
        format.json { render :show, status: :created, location: @advert }
      else
        format.html { render :new }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adverts/1
  # PATCH/PUT /adverts/1.json
  def update
    respond_to do |format|
      if @advert.update(advert_params)
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { render :show, status: :ok, location: @advert }
      else
        format.html { render :edit }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to adverts_url, notice: 'Advert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advert
      @advert = Advert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advert_params
      params.require(:advert).permit(:title, :advert_type, :img, :from_url, :rank, :content)
    end
end
