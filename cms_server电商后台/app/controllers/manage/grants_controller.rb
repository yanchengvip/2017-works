class Manage::GrantsController < ApplicationController
  before_action :set_manage_grant, only: [:show, :edit, :update, :destroy]
  before_action :side_menus6
  # GET /manage/grants
  # GET /manage/grants.json
  def index
    @manage_grants = Manage::Grant.all
  end

  # GET /manage/grants/1
  # GET /manage/grants/1.json
  def show
  end

  # GET /manage/grants/new
  def new
    @manage_grant = Manage::Grant.new
  end

  # GET /manage/grants/1/edit
  def edit
  end

  # POST /manage/grants
  # POST /manage/grants.json
  def create
    @manage_grant = Manage::Grant.new(manage_grant_params)

    respond_to do |format|
      if @manage_grant.save
        format.html { redirect_to @manage_grant, notice: 'Grant was successfully created.' }
        format.json { render :show, status: :created, location: @manage_grant }
      else
        format.html { render :new }
        format.json { render json: @manage_grant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/grants/1
  # PATCH/PUT /manage/grants/1.json
  def update
    respond_to do |format|
      if @manage_grant.update(manage_grant_params)
        format.html { redirect_to @manage_grant, notice: 'Grant was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_grant }
      else
        format.html { render :edit }
        format.json { render json: @manage_grant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/grants/1
  # DELETE /manage/grants/1.json
  def destroy
    @manage_grant.destroy
    respond_to do |format|
      format.html { redirect_to manage_grants_url, notice: 'Grant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_grant
      @manage_grant = Manage::Grant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_grant_params
      params.fetch(:manage_grant, {})
    end
end
